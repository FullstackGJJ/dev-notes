/**
 * @param {number[]} nums
 * @return {number}
 * given nums = [-2,1,-3,4,-1,2,1,-5,4], expect 6
 * given nums = [1], expect 1
 * given nums = [5,4,-1,7,8], expect 23
 */
var maxSubArray = function(nums) {
    let result = nums[0];
    let total = 0;

    for (let i = 0; i < nums.length; i++) {
        if (total < 0) {
            total = 0;
        }

        total = total + nums[i];
        result = Math.max(total, result);
    }

    return result;
};
