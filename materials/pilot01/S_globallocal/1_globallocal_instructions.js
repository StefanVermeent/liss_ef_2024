//-------------------- Welcome
var globallocal_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij de <strong>Figuren</strong> taak!<br><br><br><br>"
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
      "In dit spel ziet u steeds een plaatje van een <strong>GROTE letter</strong> die bestaat uit <strong>KLEINE letters</strong>.<br><br>" +
      "Hieronder ziet u bijvoorbeeld een <strong>GROTE</strong> letter <strong>'H'</strong> die bestaat uit <strong>KLEINE</strong> letters <strong>'P'</strong>:<br><br><br>" +
      "<img height = 300 src = S_globallocal/img/black_h_of_p.png></img><br><br>",

      "<p style = 'text-align: center;'>" +
      "De figuren bevatten altijd in ieder geval de letter <strong>'H'</strong> <i>OF</i> de letter <strong>'E'</strong>, maar nooit tegelijkertijd.<br><br>" +
      "Links ziet u  een voorbeeld van een <strong>GROTE</strong> letter <strong>'F'</strong> die bestaat uit <strong>KLEINE</strong> letters <strong>'E'</strong>.<br>" +
      "Rechts ziet u een voorbeeld van een <strong>GROTE</strong> letter <strong>'H'</strong> die bestaat uit <strong>KLEINE</strong> letters <strong>'T'</strong>.<br><br>" +

      "<div class='grid-container' style='height:210px'>" +
        "<div><img style = 'height: 200px; float: left' src = S_globallocal/img/black_f_of_e_example.png></img></div>" +
        "<div></div>" +
        "<div><img style = 'height: 200px; float: right' src = S_globallocal/img/black_h_of_t_example.png></img></div>" +
      "</div><br><br>",

      "Uw taak is altijd om de letter <strong>'H'</strong> <i>OF</i> de letter <strong>'E'</strong> te vinden,<br>" +
      "en om aan te geven of het de <strong>GROTE letter</strong> is, of de <strong>KLEINE letter</strong>.",

      "<div style = 'float: left; padding-right: 150px'>Als de GROTE letter een<br>'H' of 'E' is,<br>druk dan op de 'A'-toets.<br><br>Voorbeeld:<br><img height = 200 src = S_globallocal/img/black_e_of_t.png></img></div>" +
    "<div style = 'float: right; padding-left: 150px'>Als de KLEINE letters een<br>'H' of 'E' zijn,<br>druk dan op de 'L'-toets.<br><br>Voorbeeld:<br><img height = 200 src = S_globallocal/img/black_f_of_h.png></img></div>",

    "<p style = 'text-align: center;'>" +
    "In het voorbeeld hieronder ziet u een <strong>GROTE</strong> letter <strong>'E'</strong> die bestaat uit <strong>KLEINE</strong> letters <strong>'T'</strong>.<br><br>" +
    "In dit geval zou u dus op de A-toets drukken, omdat de 'E' de GROTE letter is.<br><br>" +
    "<img height = 300 src = S_globallocal/img/black_e_of_t_example.png></img>" +
    "<br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>GROOT<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'>KLEIN<br><br>L</h1></div>",

    "<p style = 'text-align: center;'>" +
    "In het voorbeeld hieronder ziet u een <strong>GROTE</strong> letter <strong>'F'</strong> die bestaat uit <strong>KLEINE</strong> letters <strong>'H'</strong>.<br><br>" +
    "In dit geval zou u dus op de L-toets drukken, omdat de 'H' de KLEINE letter is.<br><br>" +
    "<img height = 300 src = S_globallocal/img/black_f_of_h_example.png></img>" +
    "<br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>GROOT<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'>KLEIN<br><br>L</h1></div>",

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
      "Onthoud dat u op zoek moet naar de letters <strong>'H'</strong> OF <strong>'E'</strong>.<br>" +
      "Plaats uw vingers op de 'A'-toets (GROTE letter) en 'L'-toets (KLEINE letter) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'instructions', task: 'globallocal_practice'
  }
}

var globallocal_practice = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "<p style = 'color:green;font-size:40px'>Correct!</p>",
  incorrect_text:"<p style = 'color:red;font-size:40px'>Incorrect!</p>",
  show_stim_with_feedback: false,
  feedback_duration: 1000,
  prompt: "<br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>GROOT<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'>KLEIN<br><br>L</h1></div>",
  stimulus: function(){return jsPsych.timelineVariable('stimulus')},
  data: {
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    type: function(){return jsPsych.timelineVariable('data')['type']},
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
  },
  timeline: [
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'first', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gf_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gp_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gp_Le, key_answer: 'L', data: {rule: 'local', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gh_Lt, key_answer: 'A', data: {rule: 'global', type: 'switch', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Ge_Lf, key_answer: 'A', data: {rule: 'global', type: 'repeat', variable: 'globallocal_prac', task: 'globallocal_practice'}},
    {stimulus: Gt_Le, key_answer: 'L', data: {rule: 'local', type: 'switch', variable: 'globallocal_prac', task: 'globallocal_practice'}},
  ]
}



var globallocal_practice_end = {
  type: jsPsychInstructions,
  pages: [
    "<p style = 'text-align: center;'>" +
      "Goed gedaan! U gaat nu het echte spel spelen.<br>Het spel duurt ongeveer twee minuten<br><br>" +
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
      "Druk op een willekeurige toets als u klaar bent om te starten.",
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
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globallocal'
  }
}

var globallocal_end = {
  type: jsPsychHtmlButtonResponse,
  stimulus:
  "Goed gedaan!<br><br>" +
  "U bent nu klaar met het spelen van het <strong>Figuren</strong> spel.<br><br>" +
  "Klik op 'verder' om verder te gaan.<br><br>",
  choices: ['verder'],
  data: {variable: "end", task: "globallocal"}
};
