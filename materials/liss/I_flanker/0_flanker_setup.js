//------------------------- Functions

var location_stim = function(up, down){

  // Present flanker stimuli either at the top or bottom of the screen
  var html = "<style>" +
              "divbottom{display:flex; justify-content: center; align-items: flex-end; height:300px}" +
              "divtop{display:flex; justify-content: center; align-items: flex-start; height:300px}" +
             ".topflanker{font-size:50px;}" +
             ".bottomflanker{font-size:50px;}" +
             "</style>";

  if(up != null) {
    html += "<divtop>";
    html += "<div class = 'topflanker'>";
    html += up;
    html += "</div></div>";
  }

  if(down != null) {
    html += "<divbottom>";
    html += "<div class = 'bottomflanker'>";
    html += down;
    html += "</div></div>";

  }

  return html;
};



//------------------------- Stimuli

  // Flanker stimuli
  var congruent_left = "&larr;&larr;&larr;&larr;&larr;"
  var congruent_right = "&rarr;&rarr;&rarr;&rarr;&rarr;"
  var incongruent_left = "&rarr;&rarr;&larr;&rarr;&rarr;"
  var incongruent_right = "&larr;&larr;&rarr;&larr;&larr;"


  var flanker_stimuli = [
    {stimulus: congruent_left},
    {stimulus: congruent_right},
    {stimulus: incongruent_left},
    {stimulus: incongruent_right},
  ]


  // Fixation cross
  var flanker_fixation = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: 'NO_KEYS',
  trial_duration: 1000,
  data: {
    variable: 'fixation',
    stimulus: ""
  }
}


