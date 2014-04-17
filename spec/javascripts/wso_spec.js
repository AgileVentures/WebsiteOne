describe('WebsiteOne module', function () {
    beforeEach(function () {
        WSO.define('__test__', function () {
            return jasmine.createSpyObj('factory', ['init'])
        });
        this.module = WSO.__test__;
    });

    it('should define a new WSO module called "__test__"', function () {
        expect(this.module).toBeDefined();
        expect(WSO.__test__).toBeDefined();
    });

    describe('WSO.define', function () {
        it('should have only one module defined (for testing)', function () {
            expect(WSO._modules.length).toEqual(1);
        });

        it('should not create a new module when defined with a repeated name', function () {
            WSO.define('__test__', function () {
                return { init: function () {} };
            });
            expect(WSO._modules.length).toEqual(1);
        });

        it('should not call the init method after redefining a module when _newPageLoaded is false', function () {
            var anotherFactory = jasmine.createSpyObj('another_factory', ['init']);
            WSO._newPageLoaded = false;
            WSO.define('__test__', function () {
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
                WSO.define('__another_test__', function () {
                    return anotherFactory;
                });
                expect(anotherFactory.init).not.toHaveBeenCalled();
            });

            it('should call the init method after defining a module when the _newPageLoaded is false', function () {
                WSO._newPageLoaded = false;
                WSO.define('__another_test__', function () {
                    return anotherFactory;
                });
                expect(anotherFactory.init).toHaveBeenCalled();
            });
        })
    });

    describe('WSO._init', function () {
        it('should call the init method for all modules defined', function () {
            var anotherFactory = jasmine.createSpyObj('another_factory', ['init']);
            WSO.define('__another_test__', function () {
                return anotherFactory;
            });
            WSO._init();
            expect(this.module.init).toHaveBeenCalled();
            expect(anotherFactory.init).toHaveBeenCalled();
        });

        it('should be called on the page:load event', function () {
            $(document).trigger('page:load');
            expect(this.module.init).toHaveBeenCalled();
        });
    });

    describe('WSO._clear', function () {
        it('removes all the modules', function() {
            expect(WSO.__test__).toBeDefined();
            expect(WSO._modules.length).toEqual(1);
            WSO._clear();
            expect(WSO.__test__).not.toBeDefined();
            expect(WSO._modules.length).toEqual(0)
        });
    });
});
