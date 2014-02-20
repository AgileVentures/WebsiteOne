describe('Affixed Navbar', function() {
    var affixedNav, header, main, footer;
    beforeEach(function() {
        setFixtures(sandbox({id:'main_header'}));
        appendSetFixtures(sandbox({id:'nav'}));
        appendSetFixtures(sandbox({id:'main'}));
        appendSetFixtures(sandbox({id:'footer'}));
        affixedNav = $('#nav');
        header = $('#main_header');
        main = $('#main');
        footer = $('#footer');
    });
    it('affixes after scroll if not affixed', function() {
        $(window).scroll();
        expect(affixedNav).toHaveClass('affix');
    });
});
