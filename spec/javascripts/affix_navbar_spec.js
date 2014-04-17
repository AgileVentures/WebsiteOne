describe('Affixed Navbar', function () {
    var affixedNav, header, main, footer, height, scrollTop, scroll, hasClass;
    var onScrollSpy;

    beforeEach(function () {
        setFixtures(sandbox({id: 'main_header'}));
        appendSetFixtures(sandbox({id: 'nav'}));
        appendSetFixtures(sandbox({id: 'main'}));
        appendSetFixtures(sandbox({id: 'footer'}));
        affixedNav = $('#nav');
        header = $('#main_header');
        main = $('#main');
        footer = $('#footer');
        height = spyOn($.prototype, 'height').and.callFake(function () {
            return 50
        });
        scrollTop = spyOn($.prototype, 'scrollTop').and.callThrough();
        hasClass = spyOn($.prototype, 'hasClass').and.callThrough();
        scroll = spyOn($.prototype, 'scroll').and.callThrough();

        reloadScript('affix_navbar.js');
        onScrollSpy = spyOn(WSO.AffixedNavbar, 'onScroll').and.callThrough();
        $(document).trigger('page:load');
    });

    it('should define a new WSO module called "AffixedNavbar"', function() {
        expect(WSO.AffixedNavbar).toBeDefined();
    });

    describe('AffixedNavbar.init', function() {
        it('should measure the height of the header when initialized', function() {
            expect(height).toHaveBeenCalled();
        });

        it('should check whether or not the navbar is already affixed', function() {
            expect(hasClass).toHaveBeenCalledWith('affix')
        });

        it('should pass onScroll as a callback to scroll', function() {
            expect(scroll).toHaveBeenCalledWith(WSO.AffixedNavbar.onScroll)
        });
    });

    describe('AffixedNavbar.onScroll', function() {
        it('scrolling causes onScroll to be triggered', function () {
            $(window).scroll();
            expect(onScrollSpy).toHaveBeenCalled();
        });
    });

    describe('scrolling down', function () {
        beforeEach(function () {
            scrollTop.and.callFake(function () {
                return 150;
            });
            var parseInt = spyOn(window, 'parseInt').and.callFake(function () {
                return 5;
            });
            $(window).scroll();
        });
        it('affixes navbar to top', function () {
            expect(affixedNav).toHaveClass('affix');
        });
        it('pads the margin bottom of the header appropriately', function () {
            expect(parseInt).toHaveBeenCalled();
            expect(header).toHaveCss({ 'margin-bottom': '55px' })
        });
    });

    describe('scrolling back up', function () {
        beforeEach(function () {
            affixedNav.addClass('affix');
            scrollTop.and.callFake(function () {
                return 18;
            });
            WSO.AffixedNavbar.init();
            $(window).scroll();
        });

        it('un-affixes navbar from top', function () {
            expect(affixedNav).not.toHaveClass('affix');
        });

        it('sets the margin-bottom of the header back to zero', function () {
            expect(header).toHaveCss({ 'margin-bottom': '0px' })
        });
    });
});
