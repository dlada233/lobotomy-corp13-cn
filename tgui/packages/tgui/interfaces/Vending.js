import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

const VendingRow = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    product,
    productStock,
    custom,
  } = props;
  const {
    onstation,
    department,
    user,
    jobDiscount,
  } = data;
  const free = (
    !onstation
    || product.price === 0
    || (
      !product.premium
      && department
      && user
    )
  );
  const discount = department === user?.department;
  const redPrice = Math.round(product.price * jobDiscount);
  return (
    <Table.Row>
      <Table.Cell collapsing>
        {product.img && (
          <img
            src={`data:image/jpeg;base64,${product.img}`}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }} />
        ) || (
          <span
            className={classes([
              'vending32x32',
              product.path,
            ])}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }} />
        )}
      </Table.Cell>
      <Table.Cell bold>
        {product.display_name || product.name}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Box
          color={(
            custom && 'good'
            || productStock <= 0 && 'bad'
            || productStock <= (product.max_amount / 2) && 'average'
            || 'good'
          )}>
          {custom && product.amount}
          {productStock <= 0 ? '售罄' : '有货'}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {custom && (
          <Button
            fluid
            content={data.access ? '免费' : product.price + ' 眼'}
            onClick={() => act('dispense', {
              'item': product.name,
            })} />
        ) || (
          <Button
            fluid
            disabled={(
              productStock === 0 // 自定义修改：售罄判断使用服务端返回的库存数。
              || !free && (
                !data.user
                || product.price > data.user.cash
              )
            )}
            content={(free && discount)
              ? `${redPrice} 眼` : `${product.price} 眼`}
            onClick={() => act('vend', {
              'ref': product.ref,
            })} />
        )}
      </Table.Cell>
    </Table.Row>
  );
};

export const Vending = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    user,
    onstation,
    product_records = [],
    coin_records = [],
    hidden_records = [],
    stock,
  } = data;
  let inventory;
  let custom = false;
  if (data.vending_machine_input) {
    inventory = data.vending_machine_input;
    custom = true;
  }
  else {
    inventory = [
      ...product_records,
      ...coin_records,
    ];
    if (data.extended_inventory) {
      inventory = [
        ...inventory,
        ...hidden_records,
      ];
    }
  }
  // Just in case we still have undefined values in the list
  inventory = inventory.filter(item => !!item);
  return (
    <Window
      title="自动售货机"
      width={450}
      height={600}>
      <Window.Content scrollable>
        {!!onstation && (
          <Section title="用户">
            {user && (
              <Box>
                欢迎，<b>{user.name}</b>
                {' '}
                （<b>{user.job || '无职务'}</b>）！
                <br />
                账户余额为 <b>{user.cash} 眼</b>。
              </Box>
            ) || (
              <Box color="light-grey">
                未检测到已登记的身份卡！<br />
                请联系人事主管。
              </Box>
            )}
          </Section>
        )}
        <Section title="商品">
          <Table>
            {inventory.map(product => (
              <VendingRow
                key={product.ref || product.name}
                custom={custom}
                product={product}
                productStock={custom ? product.amount : stock[product.ref]} />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
