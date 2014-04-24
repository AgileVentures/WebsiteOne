describe("ping", function() {
    it("only shows ing", function() {
        expect(ping()).toContain("ing");
    });
});