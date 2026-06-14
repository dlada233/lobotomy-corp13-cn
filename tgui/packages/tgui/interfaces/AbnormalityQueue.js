import { useBackend } from '../backend';
import { Button, Section, Flex, Box } from '../components';
import { Window } from '../layouts';

export const AbnormalityQueue = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    current,
    threatcurrent,
    enablehardcore,
  } = data;

  const items = data.choices || [];

  return (
    <Window
      title="异想体提取管理"
      width={360}
      height={400}>
      <Window.Content>
        <Flex direction="column" mb={1}>
          <Section
            title="当前所选异想体"
            bold
          ><Box as="span" color={data.colorcurrent}>[{threatcurrent}]</Box> {current}
          </Section>
        </Flex>
        <Section
          title="可用提取选项"
          scrollable>
          <Flex direction="column" mr={7}>
            <Flex
              mb={1}
              grow={1}
              direction="column"
              height="100%"
              justify="space-between">
              {items.map(item => (
                <Flex.Item key={item.name} grow={1} mb={0.3}>
                  <Button
                    icon="plus"
                    fluid
                    bold
                    content={"[" + data["threat" + item] + "] " + item}
                    color={data["color" + item]}
                    onClick={() => act("change_current", { change_current: data[item] })} />
                </Flex.Item>
              ))}
            </Flex>
          </Flex>
        </Section>
        <Section
          title="危险按钮"
          scrollable>
          <Flex direction="column" mr={7}>
            <Flex.Item grow={1} mb={0.3}>
              <Box
                bold>
                L公司对因使用下方按钮而导致的私刑和主管死亡概不负责.
              </Box>
            </Flex.Item>
            <Flex.Item grow={1} mb={0.3}>
              <Button
                icon="bomb"
                fluid
                bold
                content={"随机"}
                color="green"
                onClick={() => act("lets_roll")} />
            </Flex.Item>
            <Flex.Item grow={1} mb={0.3}>
              <Button
                icon="bomb"
                fluid
                bold
                content={"不可更改的随机"}
                color="yellow"
                onClick={() => act("fuck_it_lets_roll")} />
            </Flex.Item>
            {!!data.enablehardcore && (
              <Flex.Item grow={1} mb={0.3}>
                <Button
                  icon="bomb"
                  fluid
                  bold
                  content={"超级随机"}
                  color="red"
                  onClick={() => act("hardcore_fuck_it_lets_roll")} />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
