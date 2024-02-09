
//------------------------- Obejects to hold trial information for the practice session

// Shape instructions

var animacysize_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>Dieren en Objecten</b> spel!<br><br><br><br>"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "animacysize_practice"}
};

var animacysize_animacy_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We gaan een spel spelen waarin u steeds bepaald of iets<br><br>" +
        "<li>LEVEND of NIET-LEVEND is;<br>" +
        "<li>KLEINER of GROTER is dan een voetbal.<br>",

        "<p style = 'text-align: center;'> We zullen eerst het LEVEND/NIET-LEVEND spel spelen.<br><br>" +
        "In het LEVEND/NIET-LEVEND spel bepaalt u of een woord verwijst naar iets <strong>LEVENDS of iets NIET-LEVENDS</strong>.<br><br>" +
        "Als het woord verwijst naar iets dat LEVEND is, druk dan op de <strong>'A'-toets</strong> op uw toetsenbord.<br><br><br>Voorbeeld:<br><br>" +
        "<div style = 'text-align: center; font-size:60px'>hond</div>" +
        "<br><br><br><div>" + prompt_living + prompt_nonliving + "</div><br><br><br>",

        "Als het woord verwijst naar iets dat NIET-LEVEND is, druk dan op de <strong>'L'-toets</strong> op uw toetsenbord.<br><br><br>Voorbeeld:<br><br>" +
        "<div style = 'text-align: center; font-size:60px'>mes</div>" +
        "<br><br><br><div>" + prompt_living + prompt_nonliving + "</div><br><br><br>",

        "<p style = 'text-align: center;'> U gaat nu het LEVEND/NIET-LEVEND spel oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het LEVEND/NIET-LEVEND/spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "instructions", task: "animacysize_practice"}
};

// Animacy practice

var animacysize_animacy_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "U gaat het LEVEND/NIET-LEVEND spel nu 6 keer oefenen.<br>" +
      "Plaats uw vingers op de 'A'-toets (LEVEND) en 'L'-toets (NIET-LEVEND) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'practice_start', task: 'animacysize_practice'
  }
}

var animacysize_animacy_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<p style = 'color:green;font-size:40px'>Goed!</p>",
      incorrect_text:"<p style = 'color:red;font-size:40px'>Fout!</p>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<br><br><br><div style='width: 500px; height:50px;'>" + prompt_living + prompt_nonliving + "</div><br><br>"+
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
      data: {variable: "living_practice", rule: "animacy", condition: "repeat", task: "animacysize_practice"},
      stimulus: function(){
        stim = jsPsych.timelineVariable('stimulus');
        return stim
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return key
    }
    }
  ],
  timeline_variables: [
    {stimulus: "<div style='font-size:60px'>sardien</div>"     , key_answer: 'A'},
    {stimulus: "<div style='font-size:60px'>baksteen</div>"    , key_answer: 'L'},
    {stimulus: "<div style='font-size:60px'>struisvogel</div>" , key_answer: 'A'},
    {stimulus: "<div style='font-size:60px'>kat</div>"         , key_answer: 'A'},
    {stimulus: "<div style='font-size:60px'>auto</div>"        , key_answer: 'L'},
    {stimulus: "<div style='font-size:60px'>roeiboot</div>"    , key_answer: 'L'}
  ]
};

var animacysize_animacy_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het LEVEND/NIET-LEVEND spel nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: "living_confirmation", task: "animacysize_practice"}
};

var animacysize_animacy_practice_loop = {
  timeline: [animacysize_animacy_practice_start,animacysize_animacy_practice,cursor_on,animacysize_animacy_confirmation],
  loop_function: function(data){
    console.log(jsPsych.data.get().last(1).values()[0].response == 1)
    if(jsPsych.data.get().last(1).values()[0].response == 1){
      return true;
    } else {
      return false;
    }
  }
};

// animacy instructions

var animacysize_size_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We kunnen ook vergelijken of iets <strong>KLEINER of GROTER is dan een <i>voetbal</i></strong>.<br><br>" +
        "In het KLEINER/GROTER spel bepaalt u of een woord verwijst naar iets dat KLEINER of GROTER is dan een <i>voetbal</i>.<br><br></p>",
        "Als het woord verwijst naar iets dat KLEINER is dan een voetbal, druk dan op de <strong>'A'-toets</strong> op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div style = 'text-align: center; font-size: 60px;'>schoen</div>" +
        "<br><br><br><div>" + prompt_smaller + prompt_larger + "</div><br><br><br>",

        "als het woord verwijst naar iets dat GROTER is dan een voetbal, druk dan op de <strong>'L'-toets</strong> op uw toetsenbord:<br><br><br>Voorbeeld:<br><br>"+
        "<div style = 'text-align: center; font-size: 60px;'>vliegtuig</div>" +
        "<br><br><br><div>" + prompt_smaller + prompt_larger + "</div><br><br><br>",

        "<p style = 'text-align: center;'>U gaat nu het KLEINER/GROTER spel oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het KLEINER/GROTER spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "instructions", task: "animacysize_instructions"}
};

// animacy practice

var animacysize_size_practice_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "U gaat het KLEINER/GROTER spel nu 6 keer oefenen.<br>" +
      "Plaats uw vingers op de 'A'-toets (KLEINER) en 'L'-toets (GROTER) op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te oefenen.",
  choices: "ALL_KEYS",
  data: {
    variable: 'practice_start', task: 'animacysize_practice'
  }
}

var animacysize_size_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<p style = 'color:green;font-size:40px'>Correct!</p>",
      incorrect_text:"<p style = 'color:red;font-size:40px'>Incorrect!</p>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<br><br><br><div style='width: 500px; height:50px;'>" + prompt_smaller + prompt_larger + "</div><br><br>"+
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0'>L</h1></div>",
      data: {variable: "size_practice",rule: "size", condition: "repeat", task: "animacysize_practice"},
      stimulus: function(){
        stim = jsPsych.timelineVariable('stimulus');
        return stim
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return key
    }
    }
  ],
  timeline_variables: [
    {stimulus: "<div style='font-size:60px'>duizendpoot</div>", key_answer: 'A'},
    {stimulus: "<div style='font-size:60px'>reuzenrad</div>"   , key_answer: 'L'},
    {stimulus: "<div style='font-size:60px'>panda</div>"   , key_answer: 'L'},
    {stimulus: "<div style='font-size:60px'>potlood</div>"   , key_answer: 'A'},
    {stimulus: "<div style='font-size:60px'>giraffe</div>" , key_answer: 'L'},
    {stimulus: "<div style='font-size:60px'>pleister</div>" , key_answer: 'A'}
  ]
};

var animacysize_size_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het KLEINER/GROTER spel nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: 'size_confirmation', task: "animacysize_practice"}
};

var animacysize_size_practice_loop = {
  timeline: [animacysize_size_practice_start, animacysize_size_practice,cursor_on,animacysize_size_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].response == 1){
      return true;
    } else {
      return false;
    }
  }
};

// animacysize instructions

var animacysize_full_instructions = {
    type: jsPsychInstructions,
    pages: ["<div style = 'text-align: center;'>Goed gedaan!<br><br>" +
            "Nu gaan we beide spellen tegelijk spelen.<br><ul>" +
            "<li>Als u <strong>'LEVEND of NIET-LEVEND?'</strong> ziet, bepaal dan of het woord verwijst naar iets dan <strong>LEVEND of NIET-LEVEND is</strong>.</li>" +
            "<li>Als u <strong>'KLEINER of GROTER?'</strong> ziet, bepaal dan of het woord verwijst naar iets dat <strong>KLEINER of GROTER is dan een voetbal</strong>.</li>" +
            "</ul><p>U ziet steeds de volgende plaatjes ter herinnering:</p></div><br><br>" +
            "<div style='width: 60%; padding-left:20%; padding-right:20%;'>" +
            "<div>" + prompt_living + prompt_smaller + prompt_larger + prompt_nonliving + "</div><br><br><br><br>" +
            "<div><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div><br>" +
            "<div><p style='float: left; margin:0;'>altijd links</p><p style='float: right; margin:0;'>altijd rechts</p></div>" +
            "</div><br><br>"],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    data: {variable: "animacysize_instructions", task: "animacysize_instructions"}
};

var animacysize_test_start = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: "<p style = 'text-align: center;'>" +
      "Vanaf nu krijgt u geen feedback meer.<br><br>" +
      "Plaats uw vingers op de 'A'-toets en 'L'-toets op uw toetsenbord.<br><br><br>" +
      "Druk op een willekeurige toets als u klaar bent om te starten.",
  choices: "ALL_KEYS",
  data: {
    variable: 'test_start', task: 'animacysize'
  }
}


