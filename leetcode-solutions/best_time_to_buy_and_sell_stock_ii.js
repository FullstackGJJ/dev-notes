/**
 * @param {number[]} prices
 * @return {number}
 * given prices = [7,1,5,3,6,4], expect 7
 * given prices = [1,2,3,4,5], expect 4
 * given prices = [7,6,4,3,1], expect 0
 */
var maxProfit = function(prices) {
    const upwardPriceSlopes = prices.reduce((acc, val) => {
        if (acc.lastValue === undefined || acc.lastValue > val) {
            acc.upwardPriceValues.push([]);
        } else if (acc.lastValue <= val) {
            acc.upwardPriceValues[acc.upwardPriceValues.length - 1].push(acc.lastValue);
            acc.upwardPriceValues[acc.upwardPriceValues.length - 1].push(val);
        }
        
        acc.lastValue = val;
        return acc;
    }, {lastValue: undefined, upwardPriceValues: []})
    .upwardPriceValues
    .filter(subArray => subArray.length > 0);

    return upwardPriceSlopes.reduce((acc, val) => {
        return acc + (val[val.length - 1] - val[0]);
    }, 0);
};
