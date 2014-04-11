describe('wso/wso.js', function () {

    beforeEach(function () {
        WSO._clear();

        WSO.define('__test__', function () {
            return {
                init: function () {
                }
            }
        });

        this.module = WSO.__test__;
        WSO._newPageLoaded = true;
    });

    it('should have only one module defined (for testing)', function () {
        expect(WSO._modules.length).toEqual(1);
    });

    describe('WSO.define', function () {
        it('should define a new module under the WSO namespace', function () {
            expect(this.module).toBeDefined();
        });

        it('should not create a new module when defined with a repeated name', function () {
            WSO.define('__test__', function () {
                return { init: function () {
                } };
            });

            expect(WSO._modules.length).toEqual(1);
        });

        it('should not call the init method after redefining a module when _newPageLoaded is false', function () {
            WSO._newPageLoaded = false;
            spyOn(this.module, 'init');
            WSO.define('__test__', function () {
                return { init: function () {
                } };
            });
            expect(this.module.init).not.toHaveBeenCalled();
        });

        describe('adding a new module', function () {

            var spy;
            beforeEach(function () {
                spy = jasmine.createSpy();
            });

            it('should not call the init method after defining a module', function () {
                WSO.define('__another_test__', function () {
                    return { init: spy };
                });
                expect(spy).not.toHaveBeenCalled();
            });

            it('should call the init method after defining a module when the _newPageLoaded is false', function () {
                WSO._newPageLoaded = false;
                WSO.define('__another_test__', function () {
                    return { init: spy };
                });
                expect(spy).toHaveBeenCalled();
            });
        })
    });

});

describe('WSO._init', function () {

    it('calls init on all its modules', function () {
        var a = jasmine.createSpyObj('a', ['init']),
            b = jasmine.createSpyObj('b', ['init']);
        WSO._modules.push('a');
        WSO._modules.push('b');
        WSO.a = a;
        WSO.b = b;
        WSO._init();
        expect(a.init).toHaveBeenCalled();
        expect(b.init).toHaveBeenCalled();
    });

    it('should call the init method in the module on page:load', function () {
        spyOn(this.module, 'init');
        $(document).trigger('page:load');
        expect(this.module.init).toHaveBeenCalled();
    });
});
