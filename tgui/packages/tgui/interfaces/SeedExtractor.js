import { sortBy } from 'common/collections';
import { flow } from 'common/fp';

import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

/**
 * This method takes a seed string and splits the values
 * into an object
 */
const splitSeedString = text => {
  const re = /([^;=]+)=([^;]+)/g;
  const ret = {};
  let m;
  do {
    m = re.exec(text);
    if (m) {
      ret[m[1]] = m[2] + '';
    }
  } while (m);
  return ret;
};

/**
 * This method splits up the string "name" we get for the seeds
 * and creates an object from it include the value that is the
 * ammount
 *
 * @returns {any[]}
 */
const createSeeds = (seedStrings, seedNames) => {
  const objs = Object.keys(seedStrings).map(key => {
    const obj = splitSeedString(key);
    obj.amount = seedStrings[key];
    obj.key = key;
    obj.name = seedNames[key] || obj.name;
    return obj;
  });
  return flow([
    sortBy(item => item.name),
  ])(objs);
};

export const SeedExtractor = (props, context) => {
  const { act, data } = useBackend(context);
  const seeds = createSeeds(data.seeds, data.seedNames || {});
  return (
    <Window
      width={1000}
      height={400}>
      <Window.Content scrollable>
        <Section title="已储存的种子">
          <Table cellpadding="3" textAlign="center">
            <Table.Row header>
              <Table.Cell>名称</Table.Cell>
              <Table.Cell>寿命</Table.Cell>
              <Table.Cell>耐力</Table.Cell>
              <Table.Cell>成熟时间</Table.Cell>
              <Table.Cell>收获间隔</Table.Cell>
              <Table.Cell>产量</Table.Cell>
              <Table.Cell>效力</Table.Cell>
              <Table.Cell>不稳定性</Table.Cell>
              <Table.Cell>库存</Table.Cell>
            </Table.Row>
            {seeds.map(item => (
              <Table.Row key={item.key}>
                <Table.Cell bold>{item.name}</Table.Cell>
                <Table.Cell>{item.lifespan}</Table.Cell>
                <Table.Cell>{item.endurance}</Table.Cell>
                <Table.Cell>{item.maturation}</Table.Cell>
                <Table.Cell>{item.production}</Table.Cell>
                <Table.Cell>{item.yield}</Table.Cell>
                <Table.Cell>{item.potency}</Table.Cell>
                <Table.Cell>{item.instability}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="取出"
                    onClick={() => act('select', {
                      item: item.key,
                    })} />
                  （剩余 {item.amount} 包）
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
