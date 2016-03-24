// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
  $("#addNewTag").click(function(){
    $("#work_experience").append($("#work_experience_form").html());
  });

  $("#addNewEducationForm").click(function(){
    $("#education").append($("#education_form").html());
  });

  $("#addNewCertificationsAndLicensureForm").click(function(){
    $("#certificationsAndLicensure").append($("#certificationsAndLicensure_form").html());
  });

  $("#addNewMembershipsAndAffiliationsForm").click(function(){
    $("#membershipsAndAffiliations").append($("#membershipsAndAffiliations_form").html());
  });

  $("#instance_form").submit(function() {
      $('.skillsForm').each(function(index, value) { 
        var this1 = $(this)
        // Overwrites default '1' value and puts the value that is inside the params[:cert_or_license_abbreviations_featured] field
        // This way we know which abbreviation is featured instead of having just 1s inside params[:cert_or_license_abbreviations_featured] field
        // this1[0].childNodes[29].value = $(this)[0].childNodes[27].value;

        // left one is value of checkbox, right one is of current job title field
        // below are updated values after Bootstrap implementation
        $(this)[0].childNodes[13].childNodes[9].childNodes[1].value = $(this)[0].childNodes[3].childNodes[3].value
      });

      $('.certificationsAndLicensure').each(function(index, value) { 
        var this1 = $(this)
        // Overwrites default '1' value and puts the value that is inside the params[:cert_or_license_abbreviations_featured] field
        // This way we know which abbreviation is featured instead of having just 1s inside params[:cert_or_license_abbreviations_featured] field
        // this1[0].childNodes[9].value = $(this)[0].childNodes[7].value;

        // left one is value of checkbox, right one is of a cert/license abbreviation field
        // below are updated values after Bootstrap implementation
        $(this)[0].childNodes[3].childNodes[5].childNodes[1].value = $(this)[0].childNodes[3].childNodes[3].childNodes[3].value
      });

      $('.education').each(function(index, value) { 
        var this1 = $(this)
        // Overwrites default '1' value and puts the value that is inside the params[:cert_or_license_abbreviations_featured] field
        // This way we know which abbreviation is featured instead of having just 1s inside params[:cert_or_license_abbreviations_featured] field
        // this1[0].childNodes[29].value = $(this)[0].childNodes[27].value;

        // left one is value of checkbox, right one is of a degree abbreviation field
        // below are updated values after Bootstrap implementation
        $(this)[0].childNodes[19].childNodes[5].childNodes[1].value = $(this)[0].childNodes[19].childNodes[3].childNodes[3].value
      });
    return true;
  });

});

// shows next item in help text, hides previous one
function showHelpText(HelpTextId, currentHelpTextId, collapseSectionId, back) {

  collapseSections = ['#collapseOne', '#collapseTwo', '#collapseThree', '#collapseFour', '#collapseFive', '#collapseSix', '#collapseSeven',
                      '#collapseEight'];

  if ((HelpTextId === '#contactInformationText')) {
    $('#collapseOne').collapse('show');
    console.log('match');
  }  

  hideOtherSections(collapseSectionId);
  $(HelpTextId).toggle();
  $(currentHelpTextId).hide();

  // // if we're going to first (Contact Information) section, then toggle to show that section
  // if ((HelpTextId === '#contactInformationText') && (back === 'back')) {
  //   $('#collapseOne').collapse('toggle');
  //   $(currentHelpTextId).toggle();  
  //   $(HelpTextId).toggle();    
  // }  
  // else if (back === 'back') {
  //   $(HelpTextId).toggle();
  //   $(currentHelpTextId).toggle();
  // }
  // // if we're going to second (Description) field, then toggle Contact Information section to be hidden
  // else if (currentHelpTextId === '#contactInformationText') {
  //   $('#collapseOne').collapse('toggle');
  //   $(currentHelpTextId).toggle();  
  //   $(HelpTextId).toggle();
  // }
  // else {
  //   $(currentHelpTextId).toggle();    
  //   $(HelpTextId).toggle();
  // }
}

// shows help text when we click on section item
function showHelpTextFromMain(currentHelpTextId, mainAccordionId) {
  helpTextCollection = ['#contactInformationText', '#descriptionHelpText', '#workExperienceHelpText', '#educationHelpText', 
                        '#certificationsAndLicensureHelpText', '#mshipsAndProfessionalAffiliations', '#otherText', '#other2Text'];


  helpTextCollection.forEach(function(val) { 
    if ($('#collapseOne').attr('aria-expanded') === undefined) 
      $('#collapseOne').collapse('hide');
    if ((currentHelpTextId === '#contactInformationText') && ($('#collapseOne').attr('aria-expanded') === 'false'))
      $(currentHelpTextId).hide();
    if ((val === currentHelpTextId) && ($(mainAccordionId).attr('aria-expanded') === 'false') || 
        (val === currentHelpTextId) && ($(mainAccordionId).attr('aria-expanded') === undefined)) 
    {
      $(val).show();
      return hideOtherSections(mainAccordionId);
    }
    else
      $(val).hide();
  });
}

function hideOtherSections(currentAccordionId) {

  collapseSections = ['#collapseOne', '#collapseTwo', '#collapseThree', '#collapseFour', '#collapseFive', '#collapseSix', '#collapseSeven',
                      '#collapseEight'];

  collapseSections.forEach(function(val) {
    if (currentAccordionId !== val)
      $(val).collapse('hide');
    else
      $(val).collapse('show');
  });
}

function hideOtherHelpText(currenthelpTextId) {

  helpTextCollection = ['#contactInformationText', '#descriptionHelpText', '#workExperienceHelpText', '#educationHelpText', 
                        '#certificationsAndLicensureHelpText', '#mshipsAndProfessionalAffiliations', '#otherText', '#other2Text'];

  helpTextCollection.forEach(function(val) {
    if (currenthelpTextId !== val)
      $(val).hide();
    else
      $(val).show();
  });
}

function expandNext(currentAccordionId, nextAccordionId, nextHelpTextId) {
  
  hideOtherHelpText(nextHelpTextId);

  $(currentAccordionId).collapse('hide');
  $(nextAccordionId).collapse('show');
}

function toggler(divId) {
    $("#" + divId).toggle();
}