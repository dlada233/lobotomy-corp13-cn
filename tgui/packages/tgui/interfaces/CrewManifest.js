import { classes } from 'common/react';
import { useBackend } from "../backend";
import { Icon, Section, Table, Tooltip } from "../components";
import { Window } from "../layouts";

// LOBOTOMYCORPORATION ADDITION START
const highcommandjobs = [
  "W-Corp L3 Squad Captain",
  "Ground Commander-地面指挥官",
  "Assault Commander-突击指挥官",
  "Hana Administrator-하나协会管理员",
  "Association Section Director-协会科室主管",
  "Index Messenger-食指传令员",
  "Blade Lineage Cutthroat-剑契组首领",
  "Grand Inquisitor-大审判官",
  "Thumb Sottocapo-拇指指挥官",
  "Kurokumo Kashira-黑云会甲头",
];
// LOBOTOMYCORPORATION ADDITION END

const commandJobs = [
// LOBOTOMYCORPORATION ADDITION START
  "Hana Representative - 하나协会代表",
  "Index Proxy - 食指代行者",
  "Blade Lineage Salsu - 剑契组杀手",
  "N Corp Grosshammer",
  "Thumb Capo - 拇指队长",
  "Kurokumo Hosa - 黑云会辅佐",

  "W-Corp L2 Type A Lieutenant",

  "Lieutenant Commander-中尉副指挥官",
  "Operations Officer-作战军官",
  "Rabbit Squad Captain-兔子队队长",
  "Reindeer Squad Captain-驯鹿队队长",
  "Rhino Squad Captain-犀牛队队长",
  "Rhino Squad Captain-乌鸦队队长",

  "Base Commander-基地指挥官",
  "Support Officer-支援军官",
  "Rat Squad Leader-老鼠队队长",
  "Rooster Squad Leader-公鸡队队长",
  "Raccoon Squad Leader-浣熊队队长",
  "Roadrunner Squad Leader-走鹃队队长",
  // LOBOTOMYCORPORATION ADDITION END
  "Head of Personnel",
  "Head of Security",
  "Chief Engineer",
  "Research Director",
  "Chief Medical Officer",
];

export const CrewManifest = (props, context) => {
  const { data: { manifest, positions } } = useBackend(context);

  return (
    <Window title="Crew Manifest" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={"CrewManifest--" + dept}
            key={dept}
            title={
              dept + (dept !== "Misc"
                ? ` (${positions[dept].open} positions open)` : "")
            }
          >
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell className={"CrewManifest__Cell"}>
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Icons",
                    ])}
                    collapsing
                  >
                    {positions[dept].exceptions.includes(crewMember.rank) && (
                      <Icon className="CrewManifest__Icon" name="infinity">
                        <Tooltip
                          content="No position limit"
                          position="bottom"
                        />
                      </Icon>
                    )}
                    {crewMember.rank === "Captain" && (
                      <Icon
                        className={classes([
                          "CrewManifest__Icon",
                          "CrewManifest__Icon--Command",
                        ])}
                        name="star"
                      >
                        <Tooltip
                          content="Captain"
                          position="bottom"
                        />
                      </Icon>
                    )}
                    {/* LOBOTOMYCORPORATION ADDITION START */}
                    {highcommandjobs.includes(crewMember.rank) && (
                      <Icon
                        className={classes([
                          "CrewManifest__Icon",
                          "CrewManifest__Icon--Command",
                        ])}
                        name="star"
                      >
                        <Tooltip
                          content="Key member of command"
                          position="bottom"
                        />
                      </Icon>
                    )}
                    {/* LOBOTOMYCORPORATION ADDITION END */}
                    {commandJobs.includes(crewMember.rank) && (
                      <Icon
                        className={classes([
                          "CrewManifest__Icon",
                          "CrewManifest__Icon--Command",
                          "CrewManifest__Icon--Chevron",
                        ])}
                        name="chevron-up"
                      >
                        <Tooltip
                          content="Member of command"
                          position="bottom"
                        />
                      </Icon>
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Cell--Rank",
                    ])}
                    collapsing
                  >
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
