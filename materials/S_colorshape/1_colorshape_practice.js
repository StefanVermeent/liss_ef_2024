
//------------------------- Obejects to hold trial information for the practice session

// Shape instructions

var colorshape_welcome = {
  type: jsPsychInstructions,
  pages: [
    "Welkom bij het <b>Kleuren en Vormen</b> spel!"
  ],
  show_clickable_nav: true,
  allow_backward: true,
  key_forward: -1,
  key_backward: -1,
  button_label_next: "verder",
  data: {variable: 'welcome', task: "colorshape_practice"}
};

var colorshape_shape_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We gaan een spel spelen waarin u wisselt tussen kleuren en vormen.<br><br></p>",
        "<p style = 'text-align: center;'> We zullen eerst het VORMEN-spel spelen.<br><br>" +
        "In het VORMEN-spel kiest u het plaatje dat dezelfde VORM is als het plaatje in het midden van het scherm.<br><br></p>",
        "Als het plaatje een DRIEHOEK is, druk dan op de 'A'-toets op uw toetsenbord:<br><br><br>Voorbeeld:"+
        "<div style = 'text-align: center;'>" + yellowtriangle + "</div>" +
        "<br><br><br><div>" + prompt_tri + prompt_circle + "</div><br><br><br>",
        "Als het plaatje een CIRCEL is, druk dan op de 'L'-toets op uw toetsenbord:<br><br><br>Voorbeeld:"+
        "<div style = 'text-align: center;'>" + bluecircle + "</div>" +
        "<br><br><br><div>" + prompt_tri + prompt_circle + "</div><br><br><br>",
        "<p style = 'text-align: center;'> U gaat nu het VORMEN-spel oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het VORMEN-spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "shape_instructions", task: "colorshape_instruction"}
};

// Shape practice

var colorshape_shape_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<h1 style='text-align:center;'>Goed</h1>",
      incorrect_text:"<h1 style='text-align:center;'>Fout</h1>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<div style='width: 500px; height:50px;'>" + prompt_tri + prompt_circle + "</div><br><br>"+
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
      data: {variable: "shape_practice", rule: "shape", type: "repeat", task: "colorshape_practice"},
      stimulus: function(){
        stim = jsPsych.timelineVariable('stimulus');
        return(stim)
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return(key)
    }
    }
  ],
  randomize_order: true,
  timeline_variables: [
    {stimulus: yellowcircle_shape  , key_answer: 'L'},
    {stimulus: bluecircle_shape    , key_answer: 'L'},
    {stimulus: bluetriangle_shape  , key_answer: 'A'},
    {stimulus: yellowtriangle_shape, key_answer: 'A'}
  ]
};

var colorshape_shape_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het VORMEN-spel nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: "shape_confirmation", task: "colorshape_practice"}
};

var colorshape_shape_practice_loop = {
  timeline: [colorshape_shape_practice,colorshape_shape_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].button_pressed == 1){
      return true;
    } else {
      return false;
    }
  }
};

// Color instructions

var colorshape_color_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: center;'>We kunnen ook vergelijken op KLEUR. <br><br>In het KLEUREN-spel kiest u het plaatje dat dezelfde KLEUR heeft as het plaatje in het midden van het scherm.<br><br></p>",
        "as het plaatje GEEL is, druk dan op de 'A'-toets op uw toetsenbord:<br><br><br>Voorbeeld:"+
        "<div style = 'text-align: center;'>" + yellowcircle + "</div>" +
        "<br><br><br><div>" + prompt_yellow + prompt_blue + "</div><br><br><br>",
        "Als het plaatje BLAUW is, druk dan op de 'L'-toets op uw toetsenbord:<br><br><br>Voorbeeld:"+
        "<div style = 'text-align: center;'>" + bluetriangle + "</div>" +
        "<br><br><br><div>" + prompt_yellow + prompt_blue + "</div><br><br><br>",
        "<p style = 'text-align: center;'>U gaat nu het KLEUREN-spel oefenen.<br><br>" +
        "Antwoord zo snel als u kunt zonder fouten te maken. Af en toe een fout maken is niet erg. Ga in dat geval gewoon door.<br><br>" +
        "Klik op 'verder' om het KLEUREN-spel te oefenen.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    button_label_previous: "ga terug",
    data: {variable: "color_instructions", task: "colorshape_instructions"}
};

// Color practice

var colorshape_color_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['A','L'],
      correct_text: "<h1 style='text-align:center;'>Goed</h1>",
      incorrect_text:"<h1 style='text-align:center;'>Fout</h1>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<div style='width: 500px; height:50px;'>" + prompt_yellow + prompt_blue + "</div><br><br>"+
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0'>L</h1></div>",
      data: {variable: "color_practice",rule: "color", type: "repeat", task: "colorshape_practice"},
      stimulus: function(){
        stim = jsPsych.timelineVariable('stimulus');
        return(stim)
      },
      key_answer: function(){
        key = jsPsych.timelineVariable('key_answer');
        return(key)
    }
    }
  ],
  randomize_order: true,
  timeline_variables: [
    {stimulus: bluecircle_color     , key_answer: 'L'},
    {stimulus: yellowcircle_color   , key_answer: 'A'},
    {stimulus: bluetriangle_color   , key_answer: 'L'},
    {stimulus: yellowtriangle_color , key_answer: 'A'}
  ]
};

var colorshape_color_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Wilt u het KLEUREN-spel nog eens oefenen?</p>",
  choices: ['Nee, ik ben klaar', 'Ja, oefen nog eens'],
  prompt: "",
  data: {variable: 'color_confirmation', task: "colorshape_practice"}
};

var colorshape_color_practice_loop = {
  timeline: [colorshape_color_practice,colorshape_color_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].button_pressed == 1){
      return true;
    } else {
      return false;
    }
  }
};

// colorshape instructions

var colorshape_full_instructions = {
    type: jsPsychInstructions,
    pages: ["<div style = 'text-align: center;'>Goed gedaan!<br><br>" +
            "Nu gaan we beide spellen tegelijk spelen.<br><ul>" +
            "<li>Als u het woord VORM ziet, kies dan het plaatje dat dezelfde VORM heeft als het plaatje in het midden.</li>" +
            "<li>Als u het woord KLEUR ziet, kies dan het plaatje dat dezelfde KLEUR heeft als het plaatje in het midden.</li>" +
            "</ul><p>U ziet steeds de volgende plaatjes ter herinnering:</p></div><br><br>" +
            "<div style='width: 60%; padding-left:20%; padding-right:20%;'>" +
            "<div>" + prompt_yellow + prompt_tri + prompt_circle + prompt_blue + "</div><br><br><br><br>" +
            "<div><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div><br>" +
            "<div><p style='float: left; margin:0;'>altijd links</p><p style='float: right; margin:0;'>altijd rechts</p></div>" +
            "</div><br><br>" +
            "<p style = 'text-align: center;'><b>Vanaf nu krijgt u geen feedback meer.</b><br><br>" +
            "Klik op 'verder' om te beginnen!</p>"],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "verder",
    data: {variable: "colorshape_instructions", task: "colorshape_instructions"}
};
