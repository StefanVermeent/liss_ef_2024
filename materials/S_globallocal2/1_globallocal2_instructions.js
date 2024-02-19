
//------------------------- Obejects to hold trial information for the practice session

// Shape instructions

var globallocal2_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>VIERKANTEN en RECHTHOEKEN</b> spel!<br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "globallocal2_practice"}
};

var globallocal2_local_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We gaan een spel spelen waarin u wisselt tussen grote en kleine figuren.<br><br></p>",
        "<p style = 'text-align: center;'> We zullen eerst het spel met KLEINE figuren spelen.<br><br>" +
        "In dit spel bepaalt u of de KLEINE figuren VIERKANTEN of RECHTHOEKEN zijn.<br></p>" +
        "Het maakt hierbij niet uit in welke vorm ze naast elkaar staan.<br><br>" +
        "<div class='grid-container-practice'>" +
          "<div>" + SQsq + "</div>" +
          "<div></div>" +
          "<div>" + RECsq + "</div>" +
          "</div>",

        "Als de kleine figuren <strong>VIERKANTEN</strong> zijn zoals hieronder, druk dan op de 'A'-toets op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div class='grid-container-practice'>" +
          "<div>" + SQsq + "</div>" +
          "<div></div>" +
          "<div>" + RECsq + "</div>" +
          "</div>" +
        "<br><br><br><div style='float:left;'>" + prompt_square + '<br>' + "A</div>" + "<div style=float:right;'>" + prompt_rectangle + "<br>" + "<br>L</div><br><br><br>",

        "Als de kleine figuren <strong>RECHTHOEKEN</strong> zijn zoals hieronder, druk dan op de 'L'-toets op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div class='grid-container-practice'>" +
          "<div>" + SQrec + "</div>" +
          "<div></div>" +
          "<div>" + RECrec + "</div>" +
          "</div>" +
        "<br><br><br><div style='float:left;'>" + prompt_square + '<br>' + "A</div>" + "<div style=float:right;'>" + prompt_rectangle + "<br>" + "<br>L</div><br><br><br>",

        "Links en rechts van de figuur ziet u steeds een plaatje van een MUIS.<br>"+
        "Dit is ter herinnering dat u naar de KLEINE figuren moet kijken.<br><br>" +
        "<div style = 'align:center;'>" + mouseleft + "</div>",

        "<p style = 'text-align: center;'> U gaat nu het spel met KLEINE figuren oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "instructions", task: "globallocal2_practice"}
};

// Shape practice

var globallocal2_local_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "U gaat het spel met KLEINE figuren nu 8 keer oefenen.<br>" +
      "Plaats uw wijsvingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'instructions', task: 'globallocal2_practice'
  }
}

var globallocal2_local_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<p style = 'color:green;font-size:40px'>Goed!</p>",
      incorrect_text:"<p style = 'color:red;font-size:40px'>Fout!</p>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<br><br><br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>" + prompt_square + "<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'><br>" + prompt_rectangle +"<br><br>L</h1></div>",
      data: {variable: "local_practice", rule: "local", type: "repeat", task: "globallocal2_practice"},
      stimulus: function(){
        var stim = "<div class='grid-container'>" +
                "<div>" + mouseleft + "</div>" +
                "<div>" + jsPsych.timelineVariable('stimulus') + "</div>" +
                "<div>" + mouseright + "</div>" +
              "</div>"
        return stim
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return key
    }
    }
  ],
  randomize_order: true,
  repetitions: 2,
  timeline_variables: [
    {stimulus: RECrec, key_answer: 'L'},
    {stimulus: SQrec,  key_answer: 'L'},
    {stimulus: SQsq,   key_answer: 'A'},
    {stimulus: RECsq,  key_answer: 'A'},
  ]
};

var globallocal2_local_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het spel met KLEINE figuren nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: "local_confirmation", task: "globallocal2_practice"}
};

var globallocal2_local_practice_loop = {
  timeline: [globallocal2_local_practice_start, globallocal2_local_practice, cursor_on, globallocal2_local_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].response == 1){
      return true;
    } else {
      return false;
    }
  }
};

// Color instructions

var globallocal2_global_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We kunnen ook kijken naar de GROTE FIGUUR die door de kleine figuren gevormd wordt." +
        "<br><br>In dit spel bepaalt u of de GROTE figuur een VIERKANT of RECHTHOEK is.<br></p>" +
         "Het maakt hierbij niet uit welke vorm de kleine figuren hebben.<br><br>" +
         "<div class='grid-container-practice'>" +
          "<div>" + SQsq + "</div>" +
          "<div></div>" +
          "<div>" + SQrec + "</div>" +
          "</div>",

         "Als de GROTE figuur een <strong>VIERKANT</strong> is zoals hieronder, druk dan op de 'A'-toets op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div class='grid-container-practice'>" +
          "<div>" + SQsq + "</div>" +
          "<div></div>" +
          "<div>" + SQrec + "</div>" +
          "</div>" +
        "<br><br><br><div style='float:left;'>" + prompt_square + '<br>' + "A</div>" + "<div style=float:right;'>" + prompt_rectangle + "<br>" + "<br>L</div><br><br><br>",

        "Als de GROTE figuur een <strong>RECHTHOEK</strong> is zoals hieronder, druk dan op de 'L'-toets op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div class='grid-container-practice'>" +
          "<div>" + RECrec + "</div>" +
          "<div></div>" +
          "<div>" + RECsq + "</div>" +
          "</div>" +
        "<br><br><br><div style='float:left;'>" + prompt_square + '<br>' + "A</div>" + "<div style=float:right;'>" + prompt_rectangle + "<br>" + "<br>L</div><br><br><br>",

        "Links en rechts van de figuur ziet u steeds een plaatje van een OLIFANT.<br>"+
        "Dit is ter herinnering dat u naar de GROTE figuur moet kijken.<br><br>" +
         "<div style = 'align:center;'>" + elephantleft + "</div>",

        "<p style = 'text-align: center;'> U gaat nu het spel met GROTE figuren oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "instructions", task: "globallocal2_practice"}
};

// Color practice

var globallocal2_global_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "U gaat het spel met GROTE figuren nu 8 keer oefenen.<br>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'instructions', task: 'globallocal2_practice'
  }
}

var globallocal2_global_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<p style = 'color:green;font-size:40px'>Correct!</p>",
      incorrect_text:"<p style = 'color:red;font-size:40px'>Incorrect!</p>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<br><br><br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>" + prompt_square + "<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'><br>" + prompt_rectangle +"<br><br>L</h1></div>",
      data: {variable: "global_practice", rule: "global", type: "repeat", task: "globallocal2_practice"},
      stimulus: function(){
        var stim = "<div class='grid-container'>" +
                "<div>" + elephantleft + "</div>" +
                "<div>" + jsPsych.timelineVariable('stimulus') + "</div>" +
                "<div>" + elephantright + "</div>" +
              "</div>"
        return stim
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return key
    }
    }
  ],
  randomize_order: true,
  repetitions: 2,
  timeline_variables: [
    {stimulus: RECrec, key_answer: 'L'},
    {stimulus: SQrec,  key_answer: 'A'},
    {stimulus: SQsq,   key_answer: 'A'},
    {stimulus: RECsq,  key_answer: 'L'},
  ]
};

var globallocal2_global_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het spel met GROTE figuren nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: 'global_confirmation', task: "globallocal2_practice"}
};

var globallocal2_global_practice_loop = {
  timeline: [globallocal2_global_practice_start, globallocal2_global_practice, cursor_on, globallocal2_global_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].response == 1){
      return true;
    } else {
      return false;
    }
  }
};

// globallocal instructions

var globallocal2_full_instructions = {
    type: jsPsychInstructions,
    pages: ["<div style = 'text-align: center;'>Goed gedaan!<br><br>" +
            "Nu gaan we beide spellen tegelijk spelen.<br><ul>" +
            "<li>Als u de <strong>MUIZEN</strong> ziet, bepaal dan of de <strong>KLEINE</strong> figuren VIERKANTEN of DRIEHOEKEN zijn.</li>" +
            "<li>Als u de <strong>OLIFANTEN</strong> ziet, bepaal dan of de <strong>GROTE</strong> figuur VIERKANTEN of DRIEHOEKEN zijn.</li>" +
            "</ul><p>U ziet steeds de volgende plaatjes ter herinnering:</p></div><br><br>" +
            "<br><br><br><div style='float:left;'>" + prompt_square + '<br>' + "A<br>Altijd LINKS</div>" + "<div style=float:right;'>" + prompt_rectangle + "<br>" + "<br>L<br>Altijd RECHTS</div><br><br><br>" +
            "</div><br><br>"],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    data: {variable: "instructions", task: "globallocal_practice"}
};

var globallocal2_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Vanaf nu krijgt u geen feedback meer.<br><br>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te starten.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'globallocal2'
  }
}
