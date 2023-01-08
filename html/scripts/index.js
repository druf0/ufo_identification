$(document).ready(function(){
    window.addEventListener('message', function(e){
        if (e.data.action == 'open') {
            var userInfo = e.data.array['user'][0];
            var licenseType = e.data.type;
            var licenseData = e.data.array['licenses'];
            var gender = userInfo.sex;
            var nationality = e.data.nationality;
            var male = e.data.male;
            var female = e.data.female;

            if (licenseType == 'driver' || licenseType == null) {
                $('img').show();
                $('#name').css('color', '#282828');

                if (gender.toLowerCase() == 'm') {
                    $('.male').show();
                    $('.female').hide();
                    $('#gender').text(male);
                } else {
                    $('.female').show();
                    $('.male').hide();
                    $('#gender').text(female);
                }

                $('#firstname').text(userInfo.firstname);
                $('#lastname').text(userInfo.lastname);
                $('#dob').text(userInfo.dateofbirth);
                $('#gender').text(userInfo.gender);
                $('#job').text(userInfo.job);
                $('#signature').text(userInfo.firstname + " " + userInfo.lastname);
                $('#nationality').text(nationality);
                $('#expires').text("02/09/2031");
                $('#class').text('');

                if (licenseType == 'driver') {
                    if (licenseData != null) {
                        Object.keys(licenseData).forEach(function(key) {
                            var licenseType = licenseData[key].type;

                            if (licenseType == 'drive_bike') {
                                $('#nationality').text('');
                                licenseType = 'motorcyclist';
                                classType = 'C';
                            } else if (licenseType == 'drive_truck') {
                                $('#nationality').text('');
                                licenseType = 'trucker';
                                classType = 'A';
                            } else if (licenseType == 'drive') {
                                $('#nationality').text('');
                                licenseType = 'driver';
                                classType = 'B';
                            }

                            if (licenseType == 'motorcyclist' || licenseType == 'trucker' || licenseType == 'driver') {
                                $('img').hide();
                                $('#licenses').append('<p class="licenseType">'+licenseType+'</p>');
                                $('#class').append('<p class="classType">'+classType+'</p>');
                                $('#gender').text("");
                                $('#job').text("");
                            }
                        });
                    }

                    
                    $('#identity-card').css('background', 'url(assets/images/license.png)');
            } else {
                $('#identity-card').css('background', 'url(assets/images/idcard.png)');
            }
            } else if (licenseType == 'weapon') {
                $('img').hide();
                $('#lastname').text(userInfo.lastname);
                $('#firstname').text(userInfo.firstname);
                $('#dob').text(userInfo.dateofbirth);
                $('#expires').text("06/01/2027");
                $('#job').text("");
                $('#class').text("");
                $('#identity-card').css('background', 'url(assets/images/weapon.png)');
                }
                $('#identity-card').show();
            } else if (e.data.action == 'close') {
                $('#lastname').text('');
                $('#firstname').text('');
                $('#dob').text('');
                $('#gender').text('');
                $('#signature').text('');
                $('#identity-card').hide();
                $('#licenses').html('');
                $('#nationality').html('');
            }
    })
})