describe('Affixed Navbar', function() {
    var affixedNav, header, main, footer, height, scrollTop;
    beforeEach(function() {
        setFixtures(sandbox({id:'main_header'}));
        appendSetFixtures(sandbox({id:'nav'}));
        appendSetFixtures(sandbox({id:'main'}));
        appendSetFixtures(sandbox({id:'footer'}));
        affixedNav = $('#nav');
        header = $('#main_header');
        main = $('#main');
        footer = $('#footer');
        height = spyOn($.prototype, 'height').and.callFake(function() { return 50 });
        scrollTop = spyOn($.prototype, 'scrollTop')
    });
    it('scrolling causes heights to be calculated', function() {
        $(window).scroll();
        expect(height).toHaveBeenCalled();
        expect(scrollTop).toHaveBeenCalled();
    });
    describe('scrolling down', function() {
        beforeEach(function() {
            scrollTop.and.callFake(function() { return 150 });
            $(window).scroll();
        });
        it('affixes navbar to top', function() {
            expect(affixedNav).toHaveClass('affix');
        });
        it('')
    });
    describe('scrolling back up', function() {
        beforeEach(function() {
            affixedNav.addClass('affix');
            scrollTop.and.callFake(function() { return 99 });
            $(window).scroll();
        });
        it('un-affixes navbar from top', function() {
            expect(affixedNav).not.toHaveClass('affix');
        });
    });
});
