//-------------------- Welcome
var posner_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welcome to the <b>posner</b> game!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  data: {variable: 'welcome', task: "posner_practice"}
};

//-------------------- Instructions
var posner_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>"+
      "In this game, you will see five arrows like the ones below.<br><br><br>" +
      "<div style = 'font-size: 30px'>&larr;&larr;&larr;&larr;&larr;</div><br><br><br>" +
      "Your job is to decide which way the <strong>middle arrow</strong> is pointing.<br><br><br>",

     "<p style = 'text-align: center;'>"+
      "Sometimes, all the arrows point the <strong>same</strong> way.<br><br><br>" +
      "<div style = 'font-size: 30px'>&larr;&larr;&larr;&larr;&larr;</div><br><br><br>",

     "<p style = 'text-align: center;'>"+
      "Other times, the arrows point a <strong>different</strong> way.<br><br><br>" +
      "<div style = 'font-size: 30px'>&larr;&larr;&rarr;&larr;&larr;</div><br><br><br>",

      "<p style = 'text-align: center;'>"+
      "You should <i>always</i> look at the <strong>middle arrow</strong> and ignore the others.<br><br>" +

      "<div style = 'float: left;'>If it points LEFT<br>press the LEFT (&larr;) key.</div>" +
      "<div style = 'float: right;'>If it points RIGHT<br>press the RIGHT (&rarr;) key.</div><br><br><br><br>" +

      "In the example below, the middle arrow points left,<br>" +
      "so you would press the left key.<br><br>" +
      "<div style = 'font-size: 30px'>&rarr;&rarr;&larr;&rarr;&rarr;</div></p><br><br><br>",

     "<p style = 'text-align: center;'>"+
      "Try to respond as fast and as correctly as possible.<br><br>" +
      "Click 'continue' to practice this game<br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  button_label_previous: "go back",
  data: {variable: "instructions", task: "posner_practice"}
};

//-------------------- Practice

var posner_practice_start = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus:    "<p style = 'text-align: center;'>" +
      "You will practice the game <strong>8 times</strong>.<br><br>" +
      "Place your fingers on the left (&larr;) and right (&rarr;) arrow keys.<br><br>" +
      "When you are ready to practice, press any key to start.",
  choices: "ALL_KEYS",
  data: {variable: "practice_start", task: "posner_practice"}
};


var posner_practice = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function() {
      return jsPsych.timelineVariable('practice_stim')
    },
    choices: ['ArrowLeft', 'ArrowRight'],
    data: {
      variable: 'practice',
      task: 'posner_practice',
      location: function(){
        return jsPsych.timelineVariable('location')
      },
      stimtype: function(){
        return jsPsych.timelineVariable('stimtype')
      }
    },
    on_finish: function(data) {
      if(jsPsych.pluginAPI.compareKeys(data.response, jsPsych.timelineVariable('correct_response', true))) {
        data.correct = true;
      } else {
        data.correct = false;
      }
    }
};


var posner_practice_procedure = {
  timeline: [posner_fixation, posner_practice, feedback],
  timeline_variables: [
    {location: 'top',    correct_response: 'ArrowLeft',  stimtype: 'congruent_left',    practice_stim: location_stim(up='&larr;&larr;&larr;&larr;&larr;', down=null)},
    {location: 'top',    correct_response: 'ArrowRight', stimtype: 'congruent_right',   practice_stim: location_stim(up='&rarr;&rarr;&rarr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'ArrowLeft',  stimtype: 'incongruent_left',  practice_stim: location_stim(up='&rarr;&rarr;&larr;&rarr;&rarr;', down=null)},
    {location: 'top',    correct_response: 'ArrowRight', stimtype: 'incongruent_right', practice_stim: location_stim(up='&larr;&larr;&rarr;&larr;&larr;', down=null)},
    {location: 'bottom', correct_response: 'ArrowLeft',  stimtype: 'congruent_left',    practice_stim: location_stim(up=null, down='&larr;&larr;&larr;&larr;&larr;')},
    {location: 'bottom', correct_response: 'ArrowRight', stimtype: 'congruent_right',   practice_stim: location_stim(up=null, down='&rarr;&rarr;&rarr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'ArrowLeft',  stimtype: 'incongruent_left',  practice_stim: location_stim(up=null, down='&rarr;&rarr;&larr;&rarr;&rarr;')},
    {location: 'bottom', correct_response: 'ArrowRight', stimtype: 'incongruent_right', practice_stim: location_stim(up=null, down='&larr;&larr;&rarr;&larr;&larr;')},
  ],
  randomize_order: true,
  repetitions: 1,
};



// Finish Practice trials
var posner_practice_finish = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: "<p style = 'text-align: center;'>" +
  "Great job!<br><br>" +
  "You will now play the actual game.<br><br>" +
  "The game will last for about two minutes. From now on you will not receive feedback after each response.<br><br>" +
  "Press any key to begin! <br><br>",
  choices: "ALL_KEYS",
  data: {variable: "practice_finish", task: "posner_practice"}
};

var posner_end = {
  type: jsPsychHtmlButtonResponse,
  stimulus:
  "Great job!<br><br>" +
  "You are now finished playing the <strong>posner</strong> game.<br><br>" +
  "Click 'finish' to continue.<br><br>",
  choices: ['Finish'],
  data: {variable: "end", task: "posner_practice"}
};
