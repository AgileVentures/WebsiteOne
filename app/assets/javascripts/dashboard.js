$('#tabs a').click(function (e) {
    var scrollHeight = $(document).scrollTop();
    $(this).tab('show');
    setTimeout(function () {
        $(window).scrollTop(scrollHeight);
    }, 5);
});

var defaultText = '<h3>User statistics</h3>'
$(function () {
    $('#info-box').html(defaultText);
    $('#map').vectorMap({
        map: 'world_mill_en',
        backgroundColor: 'transparent',
        zoomOnScroll: false,
        panOnDrag: true,
        regionStyle: {
            initial: {
                fill: '#FFF5E6',
                "fill-opacity": 1,
                stroke: 'solid',
                "stroke-width": 2,
                "stroke-opacity": 1
            },
            hover: {
                "fill-opacity": 0.8,
                cursor: 'pointer'
            },
            selected: {
                fill: 'yellow'
            },
            selectedHover: {}
        },
        series: {
            regions: [{
                values: usrData,
                scale: ['#FFE0B2', '#FF9900'],
                normalizeFunction: 'polynomial'
            }]
        },
        onRegionLabelShow: function (e, el, code) {
            if (usrData[code] > 0) {
                $('#info-box').html('<h3>We have ' + usrData[code] + ' users in ' + el.html() + '</h3>');
            } else {
                $('#info-box').html('<h3>No users in ' + el.html() + '</h3>');
            }
            console.log(el.html() + ' (Users: ' + usrData[code] + ')');
            //el.html(el.html()+' (Users: '+usrData[code]+')');

        },
        onRegionOut: function (event, code) {
            //console.log(map.getRegionName(code));
            $('#info-box').html(defaultText);
        }
    });
});