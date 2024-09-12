// Fixation cross
var fixation = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: '<div style="font-size:60px;">+</div>',
  choices: "NO_KEYS",
  trial_duration: 500,
  data: {
    variable: 'fixation'
  }
};

var globallocal_procedure01 = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 1000,
  show_stim_with_feedback: false,
  prompt: "<br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>GROOT<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'>KLEIN<br><br>L</h1></div>",
  stimulus: function(){return jsPsych.timelineVariable('stimulus')},
  data: {
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    type: function(){return jsPsych.timelineVariable('data')['type']},
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
  },
  timeline: [
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'first', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lp, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lt, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lt, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
  ]
}

var globallocal_procedure02 = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 1000,
  show_stim_with_feedback: false,
  prompt: "<br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>GROOT<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'>KLEIN<br><br>L</h1></div>",
  stimulus: function(){return jsPsych.timelineVariable('stimulus')},
  data: {
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    type: function(){return jsPsych.timelineVariable('data')['type']},
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
  },
  timeline: [
    {stimulus: Ge_Lt, key_answer: 'A', data: {rule: 'global', type: 'first', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lt, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Lh, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lp, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Ge_Lt, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lf, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lp, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gp_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'test', task: 'globallocal'}},
    {stimulus: Gh_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'test', task: 'globallocal'}},
    {stimulus: Gt_Lh, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'test', task: 'globallocal'}},
  ]
}


var globallocal_pp_feedback = {
  type: jsPsychSurveyText,
  questions: [
    {prompt: 'Heeft u feedback op dit spel (bijvoorbeeld: duidelijkheid van de instructies; moeilijkheidsgraad; iets wat niet goed leek te werken)?<br>We zouden het op prijs stellen als u het ons hieronder laat weten!', name: 'user_feedback', rows:5, required: false},
  ],
  data: {
    variable: "pp_feedback",
    task: "globallocal_feedback"
  }
}
