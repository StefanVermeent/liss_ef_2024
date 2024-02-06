// Task feedback during the practice trials.
var feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){

    var last_trial_rt = jsPsych.data.getLastTrialData().values()[0].rt;
    var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;

    if(last_trial_rt > 4000){
      return "<p style = 'color:red;font-size:40px'>Te langzaam!</p>";
    } else {
      if(last_trial_correct){
        return "<p style = 'color:green;font-size:40px'>Goed!</p>";
      } else {
        return "<p style = 'color:red;font-size:40px'>Fout!</p>";
      }}},
  trial_duration: 2000,
  choices: "NO_KEYS",
  data: {
    variable: 'feedback'
  }
};


  // General variables
var fullscreenmode = {
  type: jsPsychFullscreen,
  fullscreen_mode: true
};

var cursor_off = {
    type: jsPsychCallFunction,
    func: function() {
        document.body.style.cursor= "none";
    }
};

var cursor_on = {
    type: jsPsychCallFunction,
    func: function() {
        document.body.style.cursor= "auto";
    }
};
