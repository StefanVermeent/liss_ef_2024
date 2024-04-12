
var colorshape_procedure1 = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 250,
  show_stim_with_feedback: false,
  prompt: "<div style='width: 600px; height:50px;'>" + prompt_yellow + prompt_tri + prompt_circle + prompt_blue + "</div><br><br>" +
          "<div style='width: 600px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
  timeline: [
   {stimulus: yellowtriangle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'first', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowtriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowtriangle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowtriangle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowtriangle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowtriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'yellowtriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: yellowcircle_color, key_answer: 'ArrowLeft', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluetriangle_shape, key_answer: 'ArrowLeft', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
   {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
  ],
};

//------------------------- Standard Shifting - Set 2

var colorshape_procedure2 = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 250,
  show_stim_with_feedback: false,
  prompt: "<div style='width: 600px; height:50px;'>" + prompt_yellow + prompt_tri + prompt_circle + prompt_blue + "</div><br><br>" +
          "<div style='width: 600px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
  timeline: [
    {stimulus: yellowtriangle_color, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'first', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, key_answer: 'A', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, key_answer: 'L', data: {stimulus: 'yellowcircle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, key_answer: 'A', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, key_answer: 'L', data: {stimulus: 'bluetriangle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, key_answer: 'A', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, key_answer: 'A', data: {stimulus: 'yellowtriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, key_answer: 'A', data: {stimulus: 'yellowcircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, key_answer: 'A', data: {stimulus: 'bluetriangle', rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, key_answer: 'L', data: {stimulus: 'bluecircle', rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
  ]
};

var colorshape_interblock = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "Goed gedaan! U bent nu halverwege.<br>Neem even pauze als u dat nodig heeft en druk op 'verder' als u klaar bent voor de rest van het spel.<br><br>",
  choices: ['verder'],
  data: {
    task: 'colorshape_interblock',
    variable: 'colorshape_interblock'
  }
}


var colorshape_pp_feedback = {
  type: jsPsychSurveyText,
  questions: [
    {prompt: 'Heeft u feedback op dit spel (bijvoorbeeld: duidelijkheid van de instructies; moeilijkheidsgraad; iets wat niet goed leek te werken)?<br>We zouden het op prijs stellen als u het ons hieronder laat weten!', name: 'user_feedback', rows:5, required: false},
  ],
  data: {
    variable: "pp_feedback",
    task: "colorshape_feedback"
  }
}
