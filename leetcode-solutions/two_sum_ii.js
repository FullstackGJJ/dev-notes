/**
 * @param {number[]} numbers
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function(numbers, target) {
    let lowerPointerIndex = 0;
    let upperPointerIndex = numbers.length - 1;
    while (lowerPointerIndex < upperPointerIndex) {
        let summation = numbers[lowerPointerIndex] + numbers[upperPointerIndex];
        if (summation === target) {
            return [lowerPointerIndex + 1, upperPointerIndex + 1];
        } else if (summation > target) {
            upperPointerIndex--;
        } else if (summation < target) {
            lowerPointerIndex++;
        }
    }
};
