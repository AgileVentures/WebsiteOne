describe('Hello world', function() {

    beforeEach(function() {
        this.addMatchers({
            toBeDivisibleByTwo: function() {
                return (this.actual % 2) === 0;
            }
        });
    });

    it('is divisible by 2', function() {
        expect(gimmeANumber()).toBeDivisibleByTwo();
    });

});

//describe("Hello world", function() {
//    it("says hello", function() {
//        expect(helloWorld()).toEqual("Hello world!");
//    });
//});