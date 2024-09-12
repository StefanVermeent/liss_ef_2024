// FUNCTIONS

 function shuffle(array) {
  let currentIndex = array.length,  randomIndex;

  // While there remain elements to shuffle.
  while (currentIndex > 0) {

    // Pick a remaining element.
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;

    // And swap it with the current element.
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex], array[currentIndex]];
  }

  return array;
}


// GENERAL TRIALS

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
  fullscreen_mode: true,
  message: "<p>De spelletjes zullen verder gaan in <i>volledig scherm modus</i>.<br>We verzoeken u om in <i>volledig scherm modus</i> te blijven tijdens de gehele duur van de spelletjes.</p>",
  button_label: "Ga verder"
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

