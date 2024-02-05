//-------------------- Welcome
var globallocal_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij de <strong>Figuren</strong> taak!<br><br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: 'welcome', task: "globallocal_practice"}
};

//-------------------- Instructions
var globallocal_instructions = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" +
      "In dit spel ziet u steeds een plaatje van een <strong>grote letter</strong> die bestaat uit <strong>kleine letters</strong>.<br><br>" +
      "Hieronder ziet u bijvoorbeeld de letter <strong>'H'</strong> die bestaat uit de letter <strong>'P'</strong>:<br><br><br>" +
      "<img height = 300 src = S_globallocal/img/black_h_of_p.png></img><br><br>",

      "<p style = 'text-align: center;'>" +
      "De figuren bevatten altijd de letter <strong>'H'</strong> <i>OF</i> de letter <strong>'E'</strong>.<br><br>" +
      "Uw taak is altijd om de letter <strong>'H'</strong> <i>OF</i> de letter <strong>'E'</strong> te vinden,<br>" +
      "en om aan te geven of het de <strong>grote letter</strong> is, of de <strong>kleine letter</strong>.",

      "<div style = 'float: left; padding-right: 150px'>Als de GROTE letter een<br>'H' of 'E' is,<br>druk dan op de 'A'-toets.<br><br><img height = 200 src = S_globallocal/img/black_e_of_t.png></img></div>" +
    "<div style = 'float: right; padding-left: 150px'>Als de KLEINE letters een<br>'H' of 'E' zijn,<br>druk dan op de 'L'-toets.<br><br><img height = 200 src = S_globallocal/img/black_f_of_h.png></img></div>",

    "<p style = 'text-align: center;'>"+
      "Antwoord zo snel als u kunt zonder fouten te maken.<br>Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
      "Klik op 'verder' om het spel te oefenen.<br><br><br>"

  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: "instructions", task: "globallocal_practice"}
};

var globallocal_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "U gaat het spel nu 10 keer oefenen.<br>" +
      "Onthoud dat u op zoek moet naar de letters <strong>H</strong> OF <strong>'E'</strong>.<br>" +
      "Plaats uw vingers op de 'A'-toets (KLEINE letter) en 'L'-toets (GROTE letter) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets as u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'instructions', task: 'globallocal_practice'
  }
}

var globallocal_practice = {
  type: jsPsychCategorizeHtml,
  choices: ['g','l'],
  correct_text: "<h1 style='text-align:center;'>Goed</h1>",
  incorrect_text:"<h1 style='text-align:center;'>Fout</h1>",
  show_stim_with_feedback: false,
  feedback_duration: 1000,
  stimulus: function(){return(jsPsych.timelineVariable('stimulus'))},
  timeline: [
    {stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'first', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gf_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'switch', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gp_Le, key_answer: 'l', data: {rule: 'local', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gp_Le, key_answer: 'l', data: {rule: 'local', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gh_Lt, key_answer: 'g', data: {rule: 'global', type: 'switch', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Ge_Lf, key_answer: 'g', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal'}},
    {stimulus: Gt_Le, key_answer: 'l', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal'}},
  ]
}



var globallocal_practice_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" +
      "Goed gedaan! U gaat nu het echte spel spelen.<br><br>" +
      "U krijgt vanaf nu geen feedback meer."
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: "instructions", task: "globallocal_practice"}
};


var globallocal_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Onthoud dat u op zoek moet naar de letters <strong>H</strong> OF <strong>'E'</strong>.<br><br>" +
      "Plaats uw vingers op de 'A'-toets (GROTE letter) en 'L'-toets (KLEINE letters) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets as u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globallocal'
  }
}


var globallocal_interblock = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" +
      "Goed gedaan! U bent nu halverwege het spel.<br><br>" +
      "Als u wilt kunt u even pauzeren voordat u verder gaat."
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  button_label_previous: "ga terug",
  data: {variable: "test_interblock", task: "globallocal"}
};

var globallocal_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Onthoud dat u op zoek moet naar de letters <strong>H</strong> OF <strong>'E'</strong>.<br><br>" +
      "Plaats uw vingers op de 'A'-toets (GROTE letter) en 'L'-toets (KLEINE letters) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets as u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globallocal'
  }
}
