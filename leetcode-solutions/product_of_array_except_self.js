/**
 * @param {number[]} nums
 * @return {number[]}
 * given nums = [1,2,3,4], expect [24,12,8,6]
 * given nums = [-1,1,0,-3,3], expect [0,0,9,0,0]
 */
var productExceptSelf = function(nums) {
    const returnArray = Array(nums.length).fill(1);

    let left = 1;
    for (let i = 0; i < nums.length; i++) {
        returnArray[i] *= left;
        left *= nums[i];
    }

    let right = 1;
    for (let i = nums.length - 1; i >= 0; i--) {
        returnArray[i] *= right;
        right *= nums[i];
    }

    return returnArray;
};
