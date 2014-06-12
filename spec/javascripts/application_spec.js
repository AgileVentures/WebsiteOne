describe('WebsiteOne module', function () {
    beforeEach(function () {
        WebsiteOne.define('__test__', function () {
            return jasmine.createSpyObj('factory', ['init'])
        });
        this.module = WebsiteOne.__test__;
    });

    it('should define a new WebsiteOne module called "__test__"', function () {
        expect(this.module).toBeDefined();
        expect(WebsiteOne.__test__).toBeDefined();
    });

    describe('WebsiteOne.define', function () {
        it('should have only one module defined (for testing)', function () {
            expect(WebsiteOne._modules.length).toEqual(1);
        });

        it('should not create a new module when defined with a repeated name', function () {
            WebsiteOne.define('__test__', function () {
                return { init: function () {} };
            });
            expect(WebsiteOne._modules.length).toEqual(1);
        });

        it('should not call the init method after redefining a module when _newPageLoaded is false', function () {
            var anotherFactory = jasmine.createSpyObj('another_factory', ['init']);
            WebsiteOne._newPageLoaded = false;
            WebsiteOne.define('__test__', function () {
                return anotherFactory
            });
            expect(anotherFactory.init).not.toHaveBeenCalled();
            expect(this.module.init).not.toHaveBeenCalled();
        });

        describe('adding a new module', function () {
            var anotherFactory;
            beforeEach(function () {
                anotherFactory = jasmine.createSpyObj('another_factory', ['init']);
            });

            it('should not call the init method after defining a module', function () {
                WebsiteOne.define('__another_test__', function () {
                    return anotherFactory;
                });
                expect(anotherFactory.init).not.toHaveBeenCalled();
            });

            it('should call the init method after defining a module when the _newPageLoaded is false', function () {
                WebsiteOne._newPageLoaded = false;
                WebsiteOne.define('__another_test__', function () {
                    return anotherFactory;
                });
                expect(anotherFactory.init).toHaveBeenCalled();
            });
        })
    });

    describe('WebsiteOne._init', function () {
        it('should call the init method for all modules defined', function () {
            var anotherFactory = jasmine.createSpyObj('another_factory', ['init']);
            WebsiteOne.define('__another_test__', function () {
                return anotherFactory;
            });
            WebsiteOne._init();
            expect(this.module.init).toHaveBeenCalled();
            expect(anotherFactory.init).toHaveBeenCalled();
        });

        it('should be called on the page:load event', function () {
            $(document).trigger('page:load');
            expect(this.module.init).toHaveBeenCalled();
        });
    });

    describe("WebsiteOne.runOnce", function() {
        it('should always run the callback exactly', function () {
            var spy = jasmine.createSpy();
            WebsiteOne.runOnce("name", spy);
            for (var i = 0; i < 10; i++) {
              WebsiteOne._init();
            }
            expect(spy.calls.count()).toEqual(1);
        });
    });

    describe('WebsiteOne._clear', function () {
        it('removes all the modules', function() {
            expect(WebsiteOne.__test__).toBeDefined();
            expect(WebsiteOne._modules.length).toEqual(1);
            WebsiteOne._clear();
            expect(WebsiteOne.__test__).not.toBeDefined();
            expect(WebsiteOne._modules.length).toEqual(0)
        });
    });
});
