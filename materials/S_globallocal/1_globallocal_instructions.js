//-------------------- Welcome
var globloc_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welcome to the <strong>LETTER TASK!</strong.<br><br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  button_label_previous: "go back",
  data: {variable: 'welcome', task: "globloc_practice"}
};

//-------------------- Instructions
var globloc_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" + 
      "In this game, you will see pictures of <strong>big letters</strong> that are made up of <strong>small letters</strong>.<br><br>" +
      "The pictures will always contain an <strong>'H'</strong> or an <strong>'E'</strong>. These are the <strong>TARGET LETTERS</strong>.<br><br>" +
      "For example, you might see a <strong>big 'H'</strong> that is made up of <strong>small 'P's</strong>:<br><br><br>" +
      "<img height = 300 src = globallocal/img/black_h_of_p.png></img><br><br>",
      
      "Other times, you might see a <strong>big 'F'</strong> that is made up of <strong>small 'E's</strong>:<br><br><br>" +
      "<img height = 300 src = globallocal/img/black_f_of_e.png></img><br><br>",
      
    "<p style = 'text-align: center;'>" + 
      "Your job is to find the target letters (<strong>'H'</strong> or <strong>'E'</strong>) as quickly as possible<br>and indicate whether you found it as the <strong>BIG LETTER</strong> or <strong>SMALL LETTER</strong>.",
      
      //Page 5 
    "<div style = 'float: left; padding-right: 150px'>If the BIG letter is the target<br>press the 'G' key.<br><br><img height = 200 src = globallocal/img/black_e_of_t.png></img></div>" +
    "<div style = 'float: right; padding-left: 150px'>If the SMALL letters are the target<br>press the 'L' key.<br><br><img height = 200 src = globallocal/img/black_f_of_h.png></img></div>" +

    "<p style = 'text-align: center;'>" +
      "Remember, try to be as FAST and ACCURATE as possible."

  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  button_label_previous: "go back",
  data: {variable: "instructions", task: "globloc_practice"}
};

var globloc_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "You will now practice the task 10 times.<br>" +
      "Remember, the target letters are 'H' and 'E'.<br>" +
      "Place your fingers on the <strong>G (BIG)</strong> and <strong>L (SMALL)</strong> keys.<br><br><br>" +
      "When you are ready, press any key to start practicing.",
  choices: "ALL_KEYS",
  data: {
    variable: 'instructions', task: 'globloc_practice'
  }
}

var globloc_practice = {
  type: jsPsychCategorizeHtml,
  choices: ['g','l'],
  correct_text: "<h1 style='text-align:center;'>Correct</h1>",
  incorrect_text:"<h1 style='text-align:center;'>Incorrect</h1>",
  show_stim_with_feedback: false,
  feedback_duration: 1000,
  stimulus: function(){return(jsPsych.timelineVariable('stimulus'))},
  timeline: [
    {stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'first', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gf_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'switch', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gt_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gp_Le, key_answer: 'l', data: {rule: 'local', type: 'repeat', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gp_Le, key_answer: 'l', data: {rule: 'local', type: 'repeat', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'switch', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globloc_prac', task: 'globloc'}},
{stimulus: Gt_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globloc_prac', task: 'globloc'}},
  ]
}



var globloc_practice_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" + 
      "Good job! You will now be playing the real game.<br><br>" +
      "From now on, you will no longer receive feedback."
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  button_label_previous: "go back",
  data: {variable: "instructions", task: "globloc_practice"}
};


var globloc_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Remember, the target letters are 'H' and 'E'.<br><br>" +
      "Place your fingers on the <strong>G (global)</strong> and <strong>L (local)</strong> keys.<br><br>" +
      "When you are ready, press any key to start.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globloc'
  }
}


var globloc_interblock = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" + 
      "Good job! You are halfway through the game.<br><br>" +
      "If you want to, you can take some rest before completing the rest of the game."
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "continue",
  button_label_previous: "go back",
  data: {variable: "test_interblock", task: "globloc"}
};

var globloc_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Remember, the target letters are 'H' and 'E'.<br><br>" +
      "Place your fingers on the <strong>G (global)</strong> and <strong>L (local)</strong> keys.<br><br>" +
      "When you are ready, press any key to start.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globloc'
  }
}
