//------------------------- Functions

var location_stim = function(left, right){

  // Present flanker stimuli either at the top or bottom of the screen
  var html = "<style>" +
              "divleft{text-align: left; width:300px}" +
              "divright{text-align: right; width:300px}" +
             ".lefttarget{font-size:80px;}" +
             ".righttarget{font-size:80px;}" +
             "</style>";

  if(left != null) {
    html += "<divleft>";
    html += "<div class = 'lefttarget'>";
    html += left;
    html += "</div></div>";
  }

  if(left != null) {
    html += "<divright>";
    html += "<div class = 'righttarget'>";
    html += left;
    html += "</div></div>";

  }

  return html;
};



//------------------------- Stimuli

  // Flanker stimuli
  var left = "LINKS"
  var right = "RECHTS"


  var simon_stimuli = [
    {stimulus: left},
    {stimulus: right},
  ]


  // Fixation cross
  var simon_fixation = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px; width: 600px;">+</div>',
  choices: 'NO_KEYS',
  trial_duration: 1000,
  data: {
    variable: 'fixation',
    stimulus: ""
  }
}


