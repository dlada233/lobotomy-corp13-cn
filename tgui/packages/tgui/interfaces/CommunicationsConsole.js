import { sortBy } from "common/collections";
import { capitalize } from "common/string";
import { useBackend, useLocalState } from "../backend";
import { Blink, Box, Button, Dimmer, Flex, Icon, Input, Modal, Section, TextArea } from "../components";
import { Window } from "../layouts";
import { sanitizeText } from "../sanitize";

const STATE_BUYING_SHUTTLE = "buying_shuttle";
const STATE_CHANGING_STATUS = "changing_status";
const STATE_MAIN = "main";
const STATE_MESSAGES = "messages";
const WARNING = "更改警报级别可能会使某些异想体更加危险!";

// Used for whether or not you need to swipe to confirm an alert level change
const SWIPE_NEEDED = "SWIPE_NEEDED";

const sortByCreditCost = sortBy(shuttle => shuttle.creditCost);

const AlertButton = (props, context) => {
  const { act, data } = useBackend(context);
  const { alertLevelTick, canSetAlertLevel } = data;
  const { alertLevel, setShowAlertLevelConfirm } = props;
  const { alertDisabled, alertTooltip } = props;

  const thisIsCurrent = data.alertLevel === alertLevel;

  return (
    <Button
      icon="exclamation-triangle"
      color={thisIsCurrent && "good"}
      content={capitalize(alertLevel)}
      disabled={alertDisabled}
      tooltip={alertTooltip}
      onClick={() => {
        if (thisIsCurrent) {
          return;
        }

        if (canSetAlertLevel === SWIPE_NEEDED) {
          setShowAlertLevelConfirm([alertLevel, alertLevelTick]);
        } else {
          act("changeSecurityLevel", {
            newSecurityLevel: alertLevel,
          });
        }
      }}
    />
  );
};

const MessageModal = (props, context) => {
  const { data } = useBackend(context);
  const { maxMessageLength } = data;

  const [input, setInput] = useLocalState(context, props.label, "");

  const longEnough = props.minLength === undefined
    || input.length >= props.minLength;

  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}:
        </Flex.Item>

        <Flex.Item mr={2} mb={1}>
          <TextArea
            fluid
            height="20vh"
            width="80vw"
            backgroundColor="black"
            textColor="white"
            onInput={(_, value) => {
              setInput(value.substring(0, maxMessageLength));
            }}
            value={input}
          />
        </Flex.Item>

        <Flex.Item>
          <Button
            icon={props.icon}
            content={props.buttonText}
            color="good"
            disabled={!longEnough}
            tooltip={!longEnough ? "You need a longer reason." : ""}
            tooltipPosition="right"
            onClick={() => {
              if (longEnough) {
                setInput("");
                props.onSubmit(input);
              }
            }}
          />

          <Button
            icon="times"
            content="Cancel"
            color="bad"
            onClick={props.onBack}
          />
        </Flex.Item>

        {!!props.notice && (
          <Flex.Item maxWidth="90vw">{props.notice}</Flex.Item>
        )}
      </Flex>
    </Modal>
  );
};

const NoConnectionModal = () => {
  return (
    <Dimmer>
      <Flex direction="column" textAlign="center" width="300px">
        <Flex.Item>
          <Icon
            color="red"
            name="wifi"
            size={10}
          />

          <Blink>
            <div
              style={{
                background: "#db2828",
                bottom: "60%",
                left: "25%",
                height: "10px",
                position: "relative",
                transform: "rotate(45deg)",
                width: "150px",
              }}
            />
          </Blink>
        </Flex.Item>

        <Flex.Item fontSize="16px">
          A connection to the station cannot be established.
        </Flex.Item>
      </Flex>
    </Dimmer>
  );
};

const PageBuyingShuttle = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Back"
          onClick={() => act("setState", { state: STATE_MAIN })}
        />
      </Section>

      <Section>
        Budget: <b>{data.budget.toLocaleString()}</b> credits
      </Section>

      {sortByCreditCost(data.shuttles).map(shuttle => (
        <Section
          title={(
            <span
              style={{
                display: "inline-block",
                width: "70%",
              }}>
              {shuttle.name}
            </span>
          )}
          key={shuttle.ref}
          buttons={(
            <Button
              content={`${shuttle.creditCost.toLocaleString()} ahn`}
              disabled={data.budget < shuttle.creditCost}
              onClick={() => act("purchaseShuttle", {
                shuttle: shuttle.ref,
              })}
              tooltip={
                data.budget < shuttle.creditCost
                  ? `You need ${shuttle.creditCost - data.budget} more ahn.`
                  : undefined
              }
              tooltipPosition="left"
            />
          )}>
          <Box>{shuttle.description}</Box>
          {
            shuttle.prerequisites
              ? <b>Prerequisites: {shuttle.prerequisites}</b>
              : null
          }
        </Section>
      ))}
    </Box>
  );
};

const PageChangingStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const { maxStatusLineLength } = data;

  const [lineOne, setLineOne] = useLocalState(context, "lineOne", data.lineOne);
  const [lineTwo, setLineTwo] = useLocalState(context, "lineTwo", data.lineTwo);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Back"
          onClick={() => act("setState", { state: STATE_MAIN })}
        />
      </Section>

      <Section>
        <Flex direction="column">
          <Flex.Item>
            <Button
              icon="times"
              content="清除警报"
              color="bad"
              onClick={() => act("setStatusPicture", { picture: "blank" })}
            />
          </Flex.Item>

          <Flex.Item mt={1}>
            <Button
              icon="check-square-o"
              content="默认"
              onClick={() => act("setStatusPicture", { picture: "default" })}
            />

            <Button
              icon="bell-o"
              content="红色警报"
              onClick={() => act("setStatusPicture", { picture: "redalert" })}
            />

            <Button
              icon="exclamation-triangle"
              content="封锁"
              onClick={() => act("setStatusPicture", { picture: "lockdown" })}
            />

            <Button
              icon="exclamation-circle"
              content="生物危害"
              onClick={() => act("setStatusPicture", { picture: "biohazard" })}
            />

            <Button
              icon="space-shuttle"
              content="撤离载具ETA"
              onClick={() => act("setStatusPicture", { picture: "shuttle" })}
            />
          </Flex.Item>
        </Flex>
      </Section>

      <Section title="消息">
        <Flex direction="column">
          <Flex.Item mb={1}>
            <Input
              maxLength={maxStatusLineLength}
              value={lineOne}
              width="200px"
              onChange={(_, value) => setLineOne(value)}
            />
          </Flex.Item>

          <Flex.Item mb={1}>
            <Input
              maxLength={maxStatusLineLength}
              value={lineTwo}
              width="200px"
              onChange={(_, value) => setLineTwo(value)}
            />
          </Flex.Item>

          <Flex.Item>
            <Button
              icon="comment-o"
              content="消息"
              onClick={() => act("setStatusMessage", {
                lineOne,
                lineTwo,
              })}
            />
          </Flex.Item>
        </Flex>
      </Section>
    </Box>
  );
};

const PageMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    alertLevel,
    alertLevelTick,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    emagged,
    emergencyAccess,
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
    canChangeEmergency,
    noEmergencyFail,
    firstTrumpetFail,
    secondTrumpetFail,
    thirdTrumpetFail,
  } = data;

  const [callingShuttle, setCallingShuttle] = useLocalState(
    context, "calling_shuttle", false);
  const [messagingAssociates, setMessagingAssociates] = useLocalState(
    context, "messaging_associates", false);
  const [messagingSector, setMessagingSector] = useLocalState(
    context, "messaing_sector", null);
  const [requestingNukeCodes, setRequestingNukeCodes] = useLocalState(
    context, "requesting_nuke_codes", false);

  const [
    [showAlertLevelConfirm, confirmingAlertLevelTick],
    setShowAlertLevelConfirm,
  ] = useLocalState(context, "showConfirmPrompt", [null, null]);

  return (
    <Box>
      <Section title="Emergency Shuttle">
        {shuttleCalled && (
          <Button.Confirm
            icon="space-shuttle"
            content="召回应急撤离载具"
            color="bad"
            disabled={!canRecallShuttles || !shuttleRecallable}
            tooltip={(
              canRecallShuttles && (
                !shuttleRecallable && "召回应急撤离载具太迟了."
              ) || (
                "你没有召回应急撤离载具的许可."
              )
            )}
            tooltipPosition="bottom-right"
            onClick={() => act("recallShuttle")}
          />
        ) || (
          <Button
            icon="space-shuttle"
            content="呼叫应急撤离"
            disabled={shuttleCanEvacOrFailReason !== 1}
            tooltip={
              shuttleCanEvacOrFailReason !== 1
                ? shuttleCanEvacOrFailReason
                : undefined
            }
            tooltipPosition="bottom-right"
            onClick={() => setCallingShuttle(true)}
          />
        )}
        {!!shuttleCalledPreviously && (
          shuttleLastCalled && (
            <Box>
              最近的呼叫/召回可追溯至:
              {" "}<b>{shuttleLastCalled}</b>
            </Box>
          ) || (
            <Box>无法追踪最近的呼叫/召回信号.</Box>
          )
        )}
      </Section>

      {!!canSetAlertLevel && (
        <Section title="紧急等级">
          <Flex.Item>
            <Box>
              当前位于 <b>{capitalize(alertLevel)}</b>.
            </Box>
            {canChangeEmergency !== 1 && (
              <Box>
                冷却:{" "}<b>{canChangeEmergency}</b>
              </Box>
            )}
          </Flex.Item>
          <Flex justify="center">
            <Flex.Item>
              <AlertButton
                alertLevel="no emergency"
                alertDisabled={canChangeEmergency!==1||noEmergencyFail===1}
                alertTooltip={
                  noEmergencyFail === 1
                    ? "当前威胁等级无法被更改."
                    : undefined
                }
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
              <AlertButton
                alertLevel="first trumpet"
                alertDisabled={canChangeEmergency!== 1||firstTrumpetFail===1}
                alertTooltip={
                  firstTrumpetFail === 1
                    ? "当前威胁等级无法被更改."
                    : undefined
                }
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
              <AlertButton
                alertLevel="second trumpet"
                alertDisabled={canChangeEmergency !== 1||secondTrumpetFail===1}
                alertTooltip={
                  secondTrumpetFail === 1
                    ? "当前威胁等级无法被更改."
                    : undefined
                }
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
              <AlertButton
                alertLevel="third trumpet"
                alertDisabled={canChangeEmergency!==1||thirdTrumpetFail===1}
                alertTooltip={
                  thirdTrumpetFail === 1
                    ? "当前威胁等级无法被更改."
                    : undefined
                }
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="功能">
        <Flex
          direction="column">
          {!!canMakeAnnouncement && <Button
            icon="bullhorn"
            content="进行高优广播"
            onClick={() => act("makePriorityAnnouncement")}
          />}

          {!!canToggleEmergencyAccess && <Button.Confirm
            icon="id-card-o"
            content={`${emergencyAccess ? "关闭" : "开启"} 应急维护权限`}
            color={emergencyAccess ? "bad" : undefined}
            onClick={() => act("toggleEmergencyAccess")}
          />}

          <Button
            icon="desktop"
            content="设定状态显示"
            onClick={() => act("setState", { state: STATE_CHANGING_STATUS })}
          />

          <Button
            icon="envelope-o"
            content="消息列表"
            onClick={() => act("setState", { state: STATE_MESSAGES })}
          />

          {(canBuyShuttles !== 0) && <Button
            icon="shopping-cart"
            content="购买撤离载具"
            disabled={canBuyShuttles !== 1}
            // canBuyShuttles is a string detailing the fail reason
            // if one can be given
            tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
            tooltipPosition="right"
            onClick={() => act("setState", { state: STATE_BUYING_SHUTTLE })}
          />}

          {!!canMessageAssociates && <Button
            icon="comment-o"
            content={`发送消息至 ${emagged ? "[UNKNOWN]" : "CentCom"}`}
            disabled={!importantActionReady}
            onClick={() => setMessagingAssociates(true)}
          />}

          {!!canRequestNuke && <Button
            icon="radiation"
            content="请求核弹授权代码"
            disabled={!importantActionReady}
            onClick={() => setRequestingNukeCodes(true)}
          />}

          {!!emagged && <Button
            icon="undo"
            content="回复备份路由数据"
            onClick={() => act("restoreBackupRoutingData")}
          />}
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && <MessageModal
        label={`消息通过量子设备送至 ${emagged ? "[异常路由坐标]" : "CentCom"} `}
        notice="请注意，此流程费用较高，滥用将导致...终止，并且传输不保证有回应。"
        icon="bullhorn"
        buttonText="发送"
        onBack={() => setMessagingAssociates(false)}
        onSubmit={message => {
          setMessagingAssociates(false);
          act("messageAssociates", {
            message,
          });
        }}
      />}

      {!!canRequestNuke && requestingNukeCodes && <MessageModal
        label="请求核自毁代码理由"
        notice="在任何情况下，均不得滥用核对系统，传输不保证有回应."
        icon="bomb"
        buttonText="请求代码"
        onBack={() => setRequestingNukeCodes(false)}
        onSubmit={reason => {
          setRequestingNukeCodes(false);
          act("requestNukeCodes", {
            reason,
          });
        }}
      />}

      {!!callingShuttle && <MessageModal
        label="紧急情况性质"
        icon="space-shuttle"
        buttonText="呼叫撤离"
        minLength={callShuttleReasonMinLength}
        onBack={() => setCallingShuttle(false)}
        onSubmit={reason => {
          setCallingShuttle(false);
          act("callShuttle", {
            reason,
          });
        }}
      />}

      {
        !!canSetAlertLevel
        && showAlertLevelConfirm
        && confirmingAlertLevelTick === alertLevelTick
        && (
          <Modal>
            <Flex
              direction="column"
              textAlign="center"
              width="300px">
              <Flex.Item fontSize="16px" mb={2}>
                请使用ID卡确认更改
                <Box textColor="red">
                  { WARNING }
                </Box>
              </Flex.Item>

              <Flex.Item mr={2} mb={1}>
                <Button
                  icon="id-card-o"
                  content="Swipe ID"
                  color="good"
                  fontSize="16px"
                  onClick={() => act("changeSecurityLevel", {
                    newSecurityLevel: showAlertLevelConfirm,
                  })}
                />

                <Button
                  icon="times"
                  content="Cancel"
                  color="bad"
                  fontSize="16px"
                  onClick={() => setShowAlertLevelConfirm(false)}
                />
              </Flex.Item>
            </Flex>
          </Modal>
        )
      }

      {
        !!canSendToSectors
        && sectors.length > 0
        && (
          <Section title="友军部门">
            <Flex
              direction="column">
              {
                sectors.map(sectorName => (
                  <Flex.Item key={sectorName}>
                    <Button
                      content={
                        `Send a message to station in ${sectorName} sector`
                      }
                      disabled={!importantActionReady}
                      onClick={() => setMessagingSector(sectorName)}
                    />
                  </Flex.Item>
                ))
              }

              {sectors.length > 2 && (
                <Flex.Item>
                  <Button
                    content="Send a message to all allied stations"
                    disabled={!importantActionReady}
                    onClick={() => setMessagingSector("all")}
                  />
                </Flex.Item>
              )}
            </Flex>
          </Section>
        )
      }

      {
        !!canSendToSectors
        && sectors.length > 0
        && messagingSector
        && <MessageModal
          label="Message to send to allied station"
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingSector(null)}
          onSubmit={message => {
            act("sendToOtherSector", {
              destination: messagingSector,
              message,
            });

            setMessagingSector(null);
          }}
        />
      }
    </Box>
  );
};

const PageMessages = (props, context) => {
  const { act, data } = useBackend(context);
  const messages = data.messages || [];

  const children = [];

  children.push((
    <Section>
      <Button
        icon="chevron-left"
        content="返回"
        onClick={() => act("setState", { state: STATE_MAIN })}
      />
    </Section>
  ));

  const messageElements = [];

  for (const [messageIndex, message] of Object.entries(messages)) {
    let answers = null;

    if (message.possibleAnswers.length > 0) {
      answers = (
        <Box mt={1}>
          {message.possibleAnswers.map((answer, answerIndex) => (
            <Button
              content={answer}
              color={message.answered === answerIndex + 1 ? "good" : undefined}
              key={answerIndex}
              onClick={message.answered ? undefined : () => act("answerMessage", {
                message: parseInt(messageIndex, 10) + 1,
                answer: answerIndex + 1,
              })}
            />
          ))}
        </Box>
      );
    }

    const textHtml = {
      __html: sanitizeText(message.content),
    };

    messageElements.push((
      <Section
        title={message.title}
        key={messageIndex}
        buttons={(
          <Button.Confirm
            icon="trash"
            content="Delete"
            color="red"
            onClick={() => act("deleteMessage", {
              message: messageIndex + 1,
            })}
          />
        )}>
        <Box
          dangerouslySetInnerHTML={textHtml} />

        {answers}
      </Section>
    ));
  }

  children.push(messageElements.reverse());

  return children;
};

export const CommunicationsConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authenticated,
    authorizeName,
    canLogOut,
    emagged,
    hasConnection,
    page,
  } = data;

  return (
    <Window
      width={400}
      height={650}
      theme={emagged ? "syndicate" : undefined}>
      <Window.Content scrollable>
        {!hasConnection && <NoConnectionModal />}

        {(canLogOut || !authenticated)
          ? (
            <Section title="身份验证">
              <Button
                icon={authenticated ? "sign-out-alt" : "sign-in-alt"}
                content={authenticated ? `登出${authorizeName ? ` (${authorizeName})` : ""}` : "登录"}
                color={authenticated ? "bad" : "good"}
                onClick={() => act("toggleAuthentication")}
              />
            </Section>
          )
          : null}

        {!!authenticated && (
          page === STATE_BUYING_SHUTTLE && <PageBuyingShuttle />
          || page === STATE_CHANGING_STATUS && <PageChangingStatus />
          || page === STATE_MAIN && <PageMain />
          || page === STATE_MESSAGES && <PageMessages />
          || <Box>Page not implemented: {page}</Box>
        )}
      </Window.Content>
    </Window>
  );
};
