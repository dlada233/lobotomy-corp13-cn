
/obj/machinery/hydroponics
	name = "水培槽"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray"
	density = TRUE
	pixel_z = 8
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	circuit = /obj/item/circuitboard/machine/hydroponics
	idle_power_usage = 0
	///The amount of water in the tray (max 100)
	var/waterlevel = 100
	///The maximum amount of water in the tray
	var/maxwater = 100
	///How many units of nutrients will be drained in the tray.
	var/nutridrain = 1
	///The maximum nutrient of water in the tray
	var/maxnutri = 10
	///The amount of pests in the tray (max 10)
	var/pestlevel = 0
	///The amount of weeds in the tray (max 10)
	var/weedlevel = 0
	///Nutriment's effect on yield
	var/yieldmod = 1
	///Nutriment's effect on mutations
	var/mutmod = 1
	///Toxicity in the tray?
	var/toxic = 0
	///Current age
	var/age = 0
	///Is it dead?
	var/dead = FALSE
	///Its health
	var/plant_health
	///Last time it was harvested
	var/lastproduce = 0
	///Used for timing of cycles.
	var/lastcycle = 0
	///About 10 seconds / cycle
	var/cycledelay = 200
	///Ready to harvest?
	var/harvest = FALSE
	///The currently planted seed
	var/obj/item/seeds/myseed = null
	///Obtained from the quality of the parts used in the tray, determines nutrient drain rate.
	var/rating = 1
	///Can it be unwrenched to move?
	var/unwrenchable = TRUE
	///Have we been visited by a bee recently, so bees dont overpollinate one plant
	var/recent_bee_visit = FALSE
	///The last user to add a reagent to the tray, mostly for logging purposes.
	var/datum/weakref/lastuser
	///If the tray generates nutrients and water on its own
	var/self_sustaining = FALSE

/obj/machinery/hydroponics/Initialize()
	//ALRIGHT YOU DEGENERATES. YOU HAD REAGENT HOLDERS FOR AT LEAST 4 YEARS AND NONE OF YOU MADE HYDROPONICS TRAYS HOLD NUTRIENT CHEMS INSTEAD OF USING "Points".
	//SO HERE LIES THE "nutrilevel" VAR. IT'S DEAD AND I PUT IT OUT OF IT'S MISERY. USE "reagents" INSTEAD. ~ArcaneMusic, accept no substitutes.
	create_reagents(20)
	reagents.add_reagent(/datum/reagent/plantnutriment/eznutriment, 10) //Half filled nutrient trays for dirt trays to have more to grow with in prison/lavaland.
	. = ..()


/obj/machinery/hydroponics/constructable
	name = "可组装水培槽"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "hydrotray3"

/obj/machinery/hydroponics/constructable/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))
	AddComponent(/datum/component/plumbing/simple_demand)

/obj/machinery/hydroponics/constructable/proc/can_be_rotated(mob/user, rotation_type)
	return !anchored

/obj/machinery/hydroponics/constructable/RefreshParts()
	var/tmp_capacity = 0
	for (var/obj/item/stock_parts/matter_bin/M in component_parts)
		tmp_capacity += M.rating
	for (var/obj/item/stock_parts/manipulator/M in component_parts)
		rating = M.rating
	maxwater = tmp_capacity * 50 // Up to 300
	maxnutri = (tmp_capacity * 5) + STATIC_NUTRIENT_CAPACITY // Up to 50 Maximum
	reagents.maximum_volume = maxnutri
	nutridrain = 1/rating

/obj/machinery/hydroponics/constructable/examine(mob/user)
	. = ..()
	. += "<span class='notice'>按住 <b>Ctrl</b> 单击可开关自动栽培；按住 <b>Alt</b> 单击可倒空营养液。</span>"
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>状态屏显示：栽培效率为 <b>[rating*100]%</b>。</span>"


/obj/machinery/hydroponics/Destroy()
	if(myseed)
		qdel(myseed)
		myseed = null
	return ..()

/obj/machinery/hydroponics/constructable/attackby(obj/item/I, mob/user, params)
	if (user.a_intent != INTENT_HARM)
		// handle opening the panel
		if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
			return
		if(default_deconstruction_crowbar(I))
			return

	return ..()

/obj/machinery/hydroponics/bullet_act(obj/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(!myseed)
		return ..()
	if(istype(Proj , /obj/projectile/energy/floramut))
		mutate()
	else if(istype(Proj , /obj/projectile/energy/florayield))
		return myseed.bullet_act(Proj)
	else if(istype(Proj , /obj/projectile/energy/florarevolution))
		if(myseed)
			if(myseed.mutatelist.len > 0)
				myseed.instability = (myseed.instability/2)
		mutatespecie()
	else
		return ..()

/obj/machinery/hydroponics/process(delta_time)
	var/needs_update = 0 // Checks if the icon needs updating so we don't redraw empty trays every time

	if(myseed && (myseed.loc != src))
		myseed.forceMove(src)

	if(!powered() && self_sustaining)
		visible_message("<span class='warning'>[name]的自动栽培已停止！</span>")
		idle_power_usage = 0
		self_sustaining = FALSE
		update_icon()

	else if(self_sustaining)
		adjustWater(rand(1,2) * delta_time * 0.5)
		adjustWeeds(-0.5 * delta_time)
		adjustPests(-0.5 * delta_time)

	if(world.time > (lastcycle + cycledelay))
		lastcycle = world.time
		if(myseed && !dead)
			// Advance age
			age++
			if(age < myseed.maturation)
				lastproduce = age

			needs_update = 1


//Nutrients//////////////////////////////////////////////////////////////
			// Nutrients deplete at a constant rate, since new nutrients can boost stats far easier.
			apply_chemicals(lastuser?.resolve())
			if(self_sustaining)
				reagents.remove_any(min(0.5, nutridrain))
			else
				reagents.remove_any(nutridrain)

			// Lack of nutrients hurts non-weeds
			if(reagents.total_volume <= 0 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
				adjustHealth(-rand(1,3))

//Photosynthesis/////////////////////////////////////////////////////////
			// Lack of light hurts non-mushrooms
			if(isturf(loc))
				var/turf/currentTurf = loc
				var/lightAmt = currentTurf.get_lumcount()
				if(myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
					if(lightAmt < 0.2)
						adjustHealth(-1 / rating)
				else // Non-mushroom
					if(lightAmt < 0.4)
						adjustHealth(-2 / rating)

//Water//////////////////////////////////////////////////////////////////
			// Drink random amount of water
			adjustWater(-rand(1,6) / rating)

			// If the plant is dry, it loses health pretty fast, unless mushroom
			if(waterlevel <= 10 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
				adjustHealth(-rand(0,1) / rating)
				if(waterlevel <= 0)
					adjustHealth(-rand(0,2) / rating)

			// Sufficient water level and nutrient level = plant healthy but also spawns weeds
			else if(waterlevel > 10 && reagents.total_volume > 0)
				adjustHealth(rand(1,2) / rating)
				if(myseed && prob(myseed.weed_chance))
					adjustWeeds(myseed.weed_rate)
				else if(prob(5))  //5 percent chance the weed population will increase
					adjustWeeds(1 / rating)

//Toxins/////////////////////////////////////////////////////////////////

			// Too much toxins cause harm, but when the plant drinks the contaiminated water, the toxins disappear slowly
			if(toxic >= 40 && toxic < 80)
				adjustHealth(-1 / rating)
				adjustToxic(-rating * 2)
			else if(toxic >= 80) // I don't think it ever gets here tbh unless above is commented out
				adjustHealth(-3)
				adjustToxic(-rating *3)

//Pests & Weeds//////////////////////////////////////////////////////////

			if(pestlevel >= 8)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					if(myseed.potency >=30)
						myseed.adjust_potency(-rand(2,6)) //Pests eat leaves and nibble on fruit, lowering potency.
						myseed.potency = min((myseed.potency),30,100)
				else
					adjustHealth(2 / rating)
					adjustPests(-1 / rating)

			else if(pestlevel >= 4)
				if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
					if(myseed.potency >=30)
						myseed.adjust_potency(-rand(1,4))
						myseed.potency = min((myseed.potency),30,100)

				else
					adjustHealth(1 / rating)
					if(prob(50))
						adjustPests(-1 / rating)

			else if(pestlevel < 4 && myseed.get_gene(/datum/plant_gene/trait/plant_type/carnivory))
				if(prob(5))
					adjustPests(-1 / rating)

			// If it's a weed, it doesn't stunt the growth
			if(weedlevel >= 5 && !myseed.get_gene(/datum/plant_gene/trait/plant_type/weed_hardy))
				if(myseed.yield >=3)
					myseed.adjust_yield(-rand(1,2)) //Weeds choke out the plant's ability to bear more fruit.
					myseed.yield = min((myseed.yield),3,10)

//This is the part with pollination
			pollinate()

//This is where stability mutations exist now.
			if(myseed.instability >= 80)
				var/mutation_chance = myseed.instability - 75
				mutate(0, 0, 0, 0, 0, 0, 0, mutation_chance, 0) //Scaling odds of a random trait or chemical
			if(myseed.instability >= 60)
				if(prob((myseed.instability)/2) && !self_sustaining && length(myseed.mutatelist)) //Minimum 30%, Maximum 50% chance of mutating every age tick when not on autogrow.
					mutatespecie()
					myseed.instability = myseed.instability/2
			if(myseed.instability >= 40)
				if(prob(myseed.instability))
					hardmutate()
			if(myseed.instability >= 20 )
				if(prob(myseed.instability))
					mutate()

//Health & Age///////////////////////////////////////////////////////////

			// Plant dies if plant_health <= 0
			if(plant_health <= 0)
				plantdies()
				adjustWeeds(1 / rating) // Weeds flourish

			// If the plant is too old, lose health fast
			if(age > myseed.lifespan)
				adjustHealth(-rand(1,5) / rating)

			// Harvest code
			if(age > myseed.production && (age - lastproduce) > myseed.production && (!harvest && !dead))
				if(myseed && myseed.yield != -1) // Unharvestable shouldn't be harvested
					harvest = TRUE
				else
					lastproduce = age
			if(prob(5))  // On each tick, there's a 5 percent chance the pest population will increase
				adjustPests(1 / rating)
		else
			if(waterlevel > 10 && reagents.total_volume > 0 && prob(10))  // If there's no plant, the percentage chance is 10%
				adjustWeeds(1 / rating)

		// Weeeeeeeeeeeeeeedddssss
		if(weedlevel >= 10 && prob(50) && !self_sustaining) // At this point the plant is kind of fucked. Weeds can overtake the plant spot.
			if(myseed && myseed.yield >= 3)
				myseed.adjust_yield(-rand(1,2)) //Loses even more yield per tick, quickly dropping to 3 minimum.
				myseed.yield = min((myseed.yield),YIELD_WEED_MINIMUM,YIELD_WEED_MAXIMUM)
			if(!myseed)
				weedinvasion()
			needs_update = 1
		if (needs_update)
			update_icon()

		if(myseed && prob(5 * (11-myseed.production)))
			for(var/g in myseed.genes)
				if(istype(g, /datum/plant_gene/trait))
					var/datum/plant_gene/trait/selectedtrait = g
					selectedtrait.on_grow(src)
	return

/obj/machinery/hydroponics/update_icon()
	//Refreshes the icon and sets the luminosity
	cut_overlays()

	if(self_sustaining)
		if(istype(src, /obj/machinery/hydroponics/soil))
			add_atom_colour(rgb(255, 175, 0), FIXED_COLOUR_PRIORITY)
		else
			add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "gaia_blessing"))
		set_light(3)

	if(myseed)
		update_icon_plant()
		update_icon_lights()

	if(!self_sustaining)
		if(myseed?.get_gene(/datum/plant_gene/trait/glow))
			var/datum/plant_gene/trait/glow/G = myseed.get_gene(/datum/plant_gene/trait/glow)
			set_light(G.glow_range(myseed), G.glow_power(myseed), G.glow_color)
		else
			set_light(0)

	return

/obj/machinery/hydroponics/proc/update_icon_plant()
	var/mutable_appearance/plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	if(dead)
		plant_overlay.icon_state = myseed.icon_dead
	else if(harvest)
		if(!myseed.icon_harvest)
			plant_overlay.icon_state = "[myseed.icon_grow][myseed.growthstages]"
		else
			plant_overlay.icon_state = myseed.icon_harvest
	else
		var/t_growthstate = clamp(round((age / myseed.maturation) * myseed.growthstages), 1, myseed.growthstages)
		plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	add_overlay(plant_overlay)

/obj/machinery/hydroponics/proc/update_icon_lights()
	if(waterlevel <= 10)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowwater3"))
	if(reagents.total_volume <= 2)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lownutri3"))
	if(plant_health <= (myseed.endurance / 2))
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_lowhealth3"))
	if(weedlevel >= 5 || pestlevel >= 5 || toxic >= 40)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_alert3"))
	if(harvest)
		add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "over_harvest3"))


/obj/machinery/hydroponics/examine(user)
	. = ..()
	if(myseed)
		. += "<span class='info'>槽中种着<span class='name'>[myseed.PlantDisplayName()]</span>。</span>"
		if (dead)
			. += "<span class='warning'>植株已经枯死了！</span>"
		else if (harvest)
			. += "<span class='info'>作物已可收获。</span>"
		else if (plant_health <= (myseed.endurance / 2))
			. += "<span class='warning'>植株长势不佳。</span>"
	else
		. += "<span class='info'>槽中没有植物。</span>"

	. += "<span class='info'>水量：[waterlevel]/[maxwater]。</span>"
	. += "<span class='info'>营养液：[reagents.total_volume]/[maxnutri]。</span>"
	if(self_sustaining)
		. += "<span class='info'>自动栽培已开启，可防止物种突变、杂草和虫害。</span>"

	if(weedlevel >= 5)
		. += "<span class='warning'>槽里长满了杂草！</span>"
	if(pestlevel >= 5)
		. += "<span class='warning'>槽里到处都是小虫！</span>"

/**
 * What happens when a tray's weeds grow too large.
 * Plants a new weed in an empty tray, then resets the tray.
 */
/obj/machinery/hydroponics/proc/weedinvasion()
	dead = FALSE
	var/oldPlantName
	if(myseed) // In case there's nothing in the tray beforehand
		oldPlantName = myseed.PlantDisplayName()
		qdel(myseed)
		myseed = null
	else
		oldPlantName = "空槽"
	switch(rand(1,18))		// randomly pick predominative weed
		if(12 to 18)
			myseed = new /obj/item/seeds/harebell(src)
		if(10 to 11)
			myseed = new /obj/item/seeds/amanita(src)
		if(8 to 9)
			myseed = new /obj/item/seeds/chanter(src)
		if(6 to 7)
			myseed = new /obj/item/seeds/tower(src)
		if(4 to 5)
			myseed = new /obj/item/seeds/plump(src)
		else
			myseed = new /obj/item/seeds/starthistle(src)
	age = 0
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = FALSE
	weedlevel = 0 // Reset
	pestlevel = 0 // Reset
	update_icon()
	visible_message("<span class='warning'>[myseed.PlantDisplayName()]占据了原先的[oldPlantName]！</span>")
	TRAY_NAME_UPDATE

/obj/machinery/hydroponics/proc/mutate(lifemut = 2, endmut = 5, productmut = 1, yieldmut = 2, potmut = 25, wrmut = 2, wcmut = 5, traitmut = 0, stabmut = 3) // Mutates the current seed
	if(!myseed)
		return
	myseed.mutate(lifemut, endmut, productmut, yieldmut, potmut, wrmut, wcmut, traitmut, stabmut)

/obj/machinery/hydroponics/proc/hardmutate()
	mutate(4, 10, 2, 4, 50, 4, 10, 0, 4)


/obj/machinery/hydroponics/proc/mutatespecie() // Mutagent produced a new plant!
	if(!myseed || dead)
		return

	var/oldPlantName = myseed.PlantDisplayName()
	if(myseed.mutatelist.len > 0)
		var/mutantseed = pick(myseed.mutatelist)
		qdel(myseed)
		myseed = null
		myseed = new mutantseed
	else
		return

	hardmutate()
	age = 0
	plant_health = myseed.endurance
	lastcycle = world.time
	harvest = FALSE
	weedlevel = 0 // Reset

	sleep(5) // Wait a while
	update_icon()
	visible_message("<span class='warning'>[oldPlantName]突然变异成了[myseed.PlantDisplayName()]！</span>")
	TRAY_NAME_UPDATE

/obj/machinery/hydroponics/proc/mutateweed() // If the weeds gets the mutagent instead. Mind you, this pretty much destroys the old plant
	if( weedlevel > 5 )
		if(myseed)
			qdel(myseed)
			myseed = null
		var/newWeed = pick(/obj/item/seeds/liberty)
		myseed = new newWeed
		dead = FALSE
		hardmutate()
		age = 0
		plant_health = myseed.endurance
		lastcycle = world.time
		harvest = FALSE
		weedlevel = 0 // Reset

		sleep(5) // Wait a while
		update_icon()
		visible_message("<span class='warning'>[src]里的杂草变异，长出了[myseed.PlantDisplayName()]！</span>")
		TRAY_NAME_UPDATE
	else
		to_chat(usr, "<span class='warning'>[src]里稀疏的杂草似乎起了反应，却只持续了一瞬……</span>")

/**
 * Plant Death Proc.
 * Cleans up various stats for the plant upon death, including pests, harvestability, and plant health.
 */
/obj/machinery/hydroponics/proc/plantdies()
	plant_health = 0
	harvest = FALSE
	pestlevel = 0 // Pests die
	lastproduce = 0
	if(!dead)
		update_icon()
		dead = TRUE

/**
 * Plant Cross-Pollination.
 * Checks all plants in the tray's oview range, then averages out the seed's potency, instability, and yield values.
 * If the seed's instability is >= 20, the seed donates one of it's reagents to that nearby plant.
 * * Range - The Oview range of trays to which to look for plants to donate reagents.
 */
/obj/machinery/hydroponics/proc/pollinate(range = 1)
	for(var/obj/machinery/hydroponics/T in oview(src, range))
		//Here is where we check for window blocking.
		if(!Adjacent(T) && range <= 1)
			continue
		if(T.myseed && !T.dead)
			T.myseed.potency =  round(clamp((T.myseed.potency+(1/10)*(myseed.potency-T.myseed.potency)),0,100))
			T.myseed.instability =  round(clamp((T.myseed.instability+(1/10)*(myseed.instability-T.myseed.instability)),0,100))
			T.myseed.yield =  round(clamp((T.myseed.yield+(1/2)*(myseed.yield-T.myseed.yield)),0,10))
			if(myseed.instability >= 20 && prob(70) && length(T.myseed.reagents_add))
				var/list/datum/plant_gene/reagent/possible_reagents = list()
				for(var/datum/plant_gene/reagent/reag in T.myseed.genes)
					possible_reagents += reag
				var/datum/plant_gene/reagent/reagent_gene = pick(possible_reagents) //Let this serve as a lession to delete your WIP comments before merge.
				if(reagent_gene.can_add(myseed))
					if(!reagent_gene.try_upgrade_gene(myseed))
						myseed.genes += reagent_gene.Copy()
					myseed.reagents_from_genes()
					continue

/**
 * Pest Mutation Proc.
 * When a tray is mutated with high pest values, it will spawn spiders.
 * * User - Person who last added chemicals to the tray for logging purposes.
 */
/obj/machinery/hydroponics/proc/mutatepest(mob/user)
	if(pestlevel > 5)
		message_admins("[ADMIN_LOOKUPFLW(user)] 最后一次改动了孵出幼蛛的水培槽。")
		log_game("[key_name(user)] 最后一次改动了孵出幼蛛的水培槽。")
		visible_message("<span class='warning'>害虫的举动似乎有些反常……</span>")
		spawn_atom_to_turf(/obj/structure/spider/spiderling/hunter, src, 3, FALSE)
	else if(myseed)
		visible_message("<span class='warning'>种有[myseed.PlantDisplayName()]的槽里，害虫躁动了一阵，很快又安静下来……</span>")

/obj/machinery/hydroponics/attackby(obj/item/O, mob/user, params)
	//Called when mob user "attacks" it with object O
	if(IS_EDIBLE(O) || istype(O, /obj/item/reagent_containers))  // Syringe stuff (and other reagent containers now too)
		var/obj/item/reagent_containers/reagent_source = O

		if(istype(reagent_source, /obj/item/reagent_containers/syringe))
			var/obj/item/reagent_containers/syringe/syr = reagent_source
			if(syr.mode != 1)
				to_chat(user, "<span class='warning'>你无法从这株植物里抽取汁液。</span>")
				return

		if(!reagent_source.reagents.total_volume)
			to_chat(user, "<span class='warning'>[reagent_source]是空的！</span>")
			return 1

		if(reagents.total_volume >= reagents.maximum_volume && !reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
			to_chat(user, "<span class='notice'>[src]已满。</span>")
			return

		var/list/trays = list(src)//makes the list just this in cases of syringes and compost etc
		var/target = myseed ? myseed.PlantDisplayName() : src
		var/visi_msg = ""
		var/transfer_amount

		if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
			visi_msg="[user]把[reagent_source]当作堆肥，撒在[target]上"
			transfer_amount = reagent_source.reagents.total_volume
			SEND_SIGNAL(reagent_source, COMSIG_ITEM_ON_COMPOSTED, user)
		else
			transfer_amount = reagent_source.amount_per_transfer_from_this
			if(istype(reagent_source, /obj/item/reagent_containers/syringe/))
				var/obj/item/reagent_containers/syringe/syr = reagent_source
				visi_msg="[user]用[syr]给[target]注射了试剂"
				if(syr.reagents.total_volume <= syr.amount_per_transfer_from_this)
					syr.mode = 0
			// Beakers, bottles, buckets, etc.
			if(reagent_source.is_drainable())
				playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		if(visi_msg)
			visible_message("<span class='notice'>[visi_msg]。</span>")

		for(var/obj/machinery/hydroponics/H in trays)
		//cause I don't want to feel like im juggling 15 tamagotchis and I can get to my real work of ripping flooring apart in hopes of validating my life choices of becoming a space-gardener
			//This was originally in apply_chemicals, but due to apply_chemicals only holding nutrients, we handle it here now.
			if(reagent_source.reagents.has_reagent(/datum/reagent/water, 1))
				var/water_amt = reagent_source.reagents.get_reagent_amount(/datum/reagent/water) * transfer_amount / reagent_source.reagents.total_volume
				H.adjustWater(round(water_amt))
				reagent_source.reagents.remove_reagent(/datum/reagent/water, water_amt)
			reagent_source.reagents.trans_to(H.reagents, transfer_amount, transfered_by = user)
			lastuser = WEAKREF(user)
			if(IS_EDIBLE(reagent_source) || istype(reagent_source, /obj/item/reagent_containers/pill))
				qdel(reagent_source)
				H.update_icon()
				return 1
			H.update_icon()
		if(reagent_source) // If the source wasn't composted and destroyed
			reagent_source.update_icon()
		return 1

	else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/sample))
		if(!myseed)
			if(istype(O, /obj/item/seeds/kudzu))
				investigate_log("被[key_name(user)]种下葛藤，位置为[AREACOORD(src)]","kudzu")
			if(!user.transferItemToLoc(O, src))
				return
			to_chat(user, "<span class='notice'>你种下了[O]。</span>")
			dead = FALSE
			myseed = O
			TRAY_NAME_UPDATE
			age = 1
			plant_health = myseed.endurance
			lastcycle = world.time
			update_icon()
			return
		else
			to_chat(user, "<span class='warning'>[src]里已经种了东西！</span>")
			return

	else if(istype(O, /obj/item/plant_analyzer))
		var/obj/item/plant_analyzer/P_analyzer = O
		if(myseed)
			if(P_analyzer.scan_mode == PLANT_SCANMODE_STATS)
				to_chat(user, "*** <B>[myseed.PlantDisplayName()]</B> ***" )
				to_chat(user, "- 株龄：<span class='notice'>[age]</span>")
				var/list/text_string = myseed.get_analyzer_text()
				if(text_string)
					to_chat(user, text_string)
					to_chat(user, "*---------*")
			if(myseed.reagents_add && P_analyzer.scan_mode == PLANT_SCANMODE_CHEMICALS)
				to_chat(user, "- <B>植物试剂</B> -")
				to_chat(user, "*---------*")
				for(var/datum/plant_gene/reagent/G in myseed.genes)
					to_chat(user, "<span class='notice'>- [G.get_name()] -</span>")
				to_chat(user, "*---------*")
		else
			to_chat(user, "<B>未发现植物。</B>")
		to_chat(user, "- 杂草：<span class='notice'>[weedlevel] / 10</span>")
		to_chat(user, "- 虫害：<span class='notice'>[pestlevel] / 10</span>")
		to_chat(user, "- 毒性：<span class='notice'>[toxic] / 100</span>")
		to_chat(user, "- 水量：<span class='notice'>[waterlevel] / [maxwater]</span>")
		to_chat(user, "- 营养液：<span class='notice'>[reagents.total_volume] / [maxnutri]</span>")
		to_chat(user, "")
		return

	else if(istype(O, /obj/item/cultivator))
		if(weedlevel > 0)
			user.visible_message("<span class='notice'>[user]拔掉了杂草。</span>", "<span class='notice'>你拔掉了杂草。</span>")
			weedlevel = 0
			update_icon()
			return
		else
			to_chat(user, "<span class='warning'>这里没有杂草可拔。</span>")
			return

	else if(istype(O, /obj/item/secateurs))
		if(!myseed)
			to_chat(user, "<span class='notice'>这里没有植物。</span>")
			return
		else if(!harvest)
			to_chat(user, "<span class='notice'>植物成熟后才能截取接穗。</span>")
			return
		else if(myseed.grafted)
			to_chat(user, "<span class='notice'>这株植物已经取过接穗了。</span>")
			return
		else
			user.visible_message("<span class='notice'>[user]剪下了一段[src]里的植物枝条。</span>", "<span class='notice'>你小心地剪下一段枝条作接穗。</span>")
			var/obj/item/graft/snip = myseed.create_graft()
			if(!snip)
				return // The plant did not return a graft.

			snip.forceMove(drop_location())
			myseed.grafted = TRUE
			adjustHealth(-5)
			return

	else if(istype(O, /obj/item/geneshears))
		if(!myseed)
			to_chat(user, "<span class='notice'>槽中没有植物。</span>")
			return
		if(plant_health <= GENE_SHEAR_MIN_HEALTH)
			to_chat(user, "<span class='notice'>这株植物太虚弱，经不起修剪。</span>")
			return

		var/list/current_traits = list()
		for(var/datum/plant_gene/gene in myseed.genes)
			if(istype(gene, /datum/plant_gene/core) || (istype(gene,/datum/plant_gene/trait/plant_type)) || islist(gene))
				continue
			if(!(gene.mutability_flags & PLANT_GENE_REMOVABLE) || !(gene.mutability_flags & PLANT_GENE_EXTRACTABLE))
				continue //No bypassing unextractable or essential genes.
			current_traits[gene.name] = gene
		var/removed_trait = (input(user, "选择要从[myseed.PlantDisplayName()]移除的性状。", "移除植物性状") as null|anything in sortList(current_traits))
		if(removed_trait == null)
			return
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!myseed)
			return
		if(plant_health <= GENE_SHEAR_MIN_HEALTH) //Check health again to make sure they're not keeping inputs open to get free shears.
			return
		for(var/datum/plant_gene/gene in myseed.genes)
			if(gene.name == removed_trait)
				if(myseed.genes.Remove(gene))
					qdel(gene)
					break
		myseed.reagents_from_genes()
		adjustHealth(-15)
		to_chat(user, "<span class='notice'>你小心地剪除了[myseed.PlantDisplayName()]的基因，植株看起来虚弱了些。</span>")
		update_icon()
		return

	else if(istype(O, /obj/item/graft))
		var/obj/item/graft/snip = O
		if(!myseed)
			to_chat(user, "<span class='notice'>槽中没有植物。</span>")
			return
		if(!myseed.apply_graft(snip))
			to_chat(user, "<span class='warning'>[myseed.PlantDisplayName()]排斥[snip]！</span>")
			return
		qdel(snip)
		to_chat(user, "<span class='notice'>你将接穗小心地嫁接到[myseed.PlantDisplayName()]上。</span>")
		return

	else if(istype(O, /obj/item/storage/bag/plants))
		attack_hand(user)
		for(var/obj/item/food/grown/G in locate(user.x,user.y,user.z))
			SEND_SIGNAL(O, COMSIG_TRY_STORAGE_INSERT, G, user, TRUE)
		return

	else if(default_unfasten_wrench(user, O))
		return

	else if(istype(O, /obj/item/shovel/spade))
		if(!myseed && !weedlevel)
			to_chat(user, "<span class='warning'>[src]里既没有作物也没有杂草！</span>")
			return
		user.visible_message("<span class='notice'>[user]开始挖出[src]里的植物……</span>",
			"<span class='notice'>你开始挖出[src]里的植物……</span>")
		if(O.use_tool(src, user, 50, volume=50) || (!myseed && !weedlevel))
			user.visible_message("<span class='notice'>[user]挖出了[src]里的植物！</span>", "<span class='notice'>你挖出了[src]里的植物！</span>")
			if(myseed) //Could be that they're just using it as a de-weeder
				age = 0
				plant_health = 0
				lastproduce = 0
				if(harvest)
					harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
				qdel(myseed)
				myseed = null
				name = initial(name)
				desc = initial(desc)
			weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
			update_icon()
			return
	else if(istype(O, /obj/item/storage/part_replacer))
		RefreshParts()
		return
	else if(istype(O, /obj/item/gun/energy/floragun))
		var/obj/item/gun/energy/floragun/flowergun = O
		if(flowergun.cell.charge < flowergun.cell.maxcharge)
			to_chat(user, "<span class='notice'>[flowergun]充满电后才能锁定变异！</span>")
			return
		if(!myseed)
			to_chat(user, "<span class='warning'>[src]里没有植物！</span>")
			return
		if(myseed.endurance <= 20)
			to_chat(user, "<span class='warning'>[myseed.PlantDisplayName()]的耐力不足以进行变异测序！</span>")
			return
		if(!myseed.mutatelist)
			to_chat(user, "<span class='warning'>[myseed.PlantDisplayName()]没有其他可变异的品种！</span>")
			return
		else
			var/list/fresh_mut_list = list(), list/name_counts = list()
			for(var/muties in myseed.mutatelist)
				var/obj/item/seeds/another_mut = new muties
				fresh_mut_list[avoid_assoc_duplicate_keys(another_mut.PlantDisplayName(), name_counts)] = muties
			var/locked_mutation = (input(user, "选择要锁定的变异品种。", "锁定植物变异") as null|anything in sortList(fresh_mut_list))
			if(!user.canUseTopic(src, BE_CLOSE) || !locked_mutation)
				return
			myseed.mutatelist = list(fresh_mut_list[locked_mutation])
			myseed.endurance = (myseed.endurance/2)
			flowergun.cell.use(flowergun.cell.charge)
			flowergun.update_icon()
			to_chat(user, "<span class='notice'>[myseed.PlantDisplayName()]的变异品种已锁定为[locked_mutation]，[flowergun]的电量耗尽了！</span>")
			return
	else
		return ..()

/obj/machinery/hydroponics/can_be_unfasten_wrench(mob/user, silent)
	if (!unwrenchable)  // case also covered by NODECONSTRUCT checks in default_unfasten_wrench
		return CANT_UNFASTEN

	return ..()

/obj/machinery/hydroponics/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(issilicon(user)) //How does AI know what plant is?
		return
	if(harvest)
		return myseed.harvest(user)

	else if(dead)
		dead = FALSE
		to_chat(user, "<span class='notice'>你清除了[src]里的枯株。</span>")
		qdel(myseed)
		myseed = null
		update_icon()
		TRAY_NAME_UPDATE
	else
		if(user)
			user.examinate(src)

/obj/machinery/hydroponics/CtrlClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(!powered())
		to_chat(user, "<span class='warning'>[name]没有电。</span>")
		return
	if(!anchored)
		return
	self_sustaining = !self_sustaining
	idle_power_usage = self_sustaining ? 5000 : 0
	to_chat(user, "<span class='notice'>你[self_sustaining ? "开启" : "关闭"]了[src]的自动栽培。[self_sustaining ? "水培槽会消耗大量电力来维持植株健康。" : ""]</span>")
	update_icon()

/obj/machinery/hydroponics/AltClick(mob/user)
	. = ..()
	if(!anchored)
		update_icon()
		return FALSE
	var/warning = alert(user, "确定要倒空水培槽里的营养液吗？","倒空营养液", "倒空", "取消")
	if(warning == "倒空" && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		reagents.clear_reagents()
		to_chat(user, "<span class='notice'>你倒空了[src]里的营养液。</span>")

/**
 * Update Tray Proc
 * Handles plant harvesting on the tray side, by clearing the sead, names, description, and dead stat.
 * Shuts off autogrow if enabled.
 * Sends messages to the cleaer about plants harvested, or if nothing was harvested at all.
 * * User - The mob who clears the tray.
 */
/obj/machinery/hydroponics/proc/update_tray(mob/user)
	harvest = FALSE
	lastproduce = age
	if(istype(myseed, /obj/item/seeds/replicapod))
		to_chat(user, "<span class='notice'>你收获了[myseed.PlantDisplayName()]。</span>")
	else if(myseed.getYield() <= 0)
		to_chat(user, "<span class='warning'>你没能收获任何有用的东西！</span>")
	else
		to_chat(user, "<span class='notice'>你从[myseed.PlantDisplayName()]上收获了 [myseed.getYield()] 份产物。</span>")
	if(!myseed.get_gene(/datum/plant_gene/trait/repeated_harvest) || istype(src, /obj/machinery/hydroponics/soil/amurdad))
		qdel(myseed)
		myseed = null
		dead = FALSE
		name = initial(name)
		desc = initial(desc)
		TRAY_NAME_UPDATE
		if(self_sustaining) //No reason to pay for an empty tray.
			idle_power_usage = 0
			self_sustaining = FALSE
	update_icon()

/// Tray Setters - The following procs adjust the tray or plants variables, and make sure that the stat doesn't go out of bounds.
/**
 * Adjust water.
 * Raises or lowers tray water values by a set value. Adding water will dillute toxicity from the tray.
 * * adjustamt - determines how much water the tray will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustWater(adjustamt)
	waterlevel = clamp(waterlevel + adjustamt, 0, maxwater)

	if(adjustamt>0)
		adjustToxic(-round(adjustamt/4))//Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.

/**
 * Adjust Health.
 * Raises the tray's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustHealth(adjustamt)
	if(myseed && !dead)
		plant_health = clamp(plant_health + adjustamt, 0, myseed.endurance)

/**
 * Adjust Health.
 * Raises the plant's plant_health stat by a given amount, with total health determined by the seed's endurance.
 * * adjustamt - Determines how much the plant_health will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustToxic(adjustamt)
	toxic = clamp(toxic + adjustamt, 0, 100)

/**
 * Adjust Pests.
 * Raises the tray's pest level stat by a given amount.
 * * adjustamt - Determines how much the pest level will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustPests(adjustamt)
	pestlevel = clamp(pestlevel + adjustamt, 0, 10)

/**
 * Adjust Weeds.
 * Raises the plant's weed level stat by a given amount.
 * * adjustamt - Determines how much the weed level will be adjusted upwards or downwards.
 */
/obj/machinery/hydroponics/proc/adjustWeeds(adjustamt)
	weedlevel = clamp(weedlevel + adjustamt, 0, 10)

/**
 * Spawn Plant.
 * Upon using strange reagent on a tray, it will spawn a killer tomato or killer tree at random.
 */
/obj/machinery/hydroponics/proc/spawnplant() // why would you put strange reagent in a hydro tray you monster I bet you also feed them blood
	var/list/livingplants = list(/mob/living/simple_animal/hostile/tree)
	var/chosen = pick(livingplants)
	var/mob/living/simple_animal/hostile/C = new chosen
	C.faction = list("plants")

///////////////////////////////////////////////////////////////////////////////
/obj/machinery/hydroponics/soil //Not actually hydroponics at all! Honk!
	name = "土壤"
	desc = "一小片泥土。"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "soil"
	gender = PLURAL
	circuit = null
	density = FALSE
	use_power = NO_POWER_USE
	flags_1 = NODECONSTRUCT_1
	unwrenchable = FALSE

/obj/machinery/hydroponics/soil/update_icon_lights()
	return // Has no lights

/obj/machinery/hydroponics/soil/attackby(obj/item/O, mob/user, params)
	if(O.tool_behaviour == TOOL_SHOVEL && !istype(O, /obj/item/shovel/spade)) //Doesn't include spades because of uprooting plants
		to_chat(user, "<span class='notice'>你清理了[src]！</span>")
		qdel(src)
	else
		return ..()

/obj/machinery/hydroponics/soil/CtrlClick(mob/user)
	return //Soil has no electricity.
