
var colorshape_test = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  key_answer: function(){return jsPsych.timelineVariable('key_answer')},
  stimulus: function(){return jsPsych.timelineVariable('stimulus')},
  feedback_duration: 250,
  show_stim_with_feedback: false,
  prompt: "<div style='width: 600px; height:50px;'>" + prompt_yellow + prompt_tri + prompt_circle + prompt_blue + "</div><br><br>" +
          "<div style='width: 600px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
  data: {
    stimulus: function(){return jsPsych.timelineVariable('stim_chr')},
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    condition: function(){return jsPsych.timelineVariable('data')['type']},
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
  }
}

var colorshape_procedure1 = {
  timeline: [colorshape_test],
  timeline_variables: [
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'first', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, stim_chr: 'yellowtriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'ArrowLeft', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'ArrowLeft', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
  ],
};



//------------------------- Standard Shifting - Set 2

var colorshape_procedure2 = {
  timeline: [colorshape_test],
  timeline_variables: [
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'color', type: 'first', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'A', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_shape, stim_chr: 'yellowcircle', key_answer: 'L', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_color, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'A', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_shape, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_color, stim_chr: 'bluetriangle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'A', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowtriangle_shape, stim_chr: 'yellowtriangle', key_answer: 'A', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: yellowcircle_color, stim_chr: 'yellowcircle', key_answer: 'A', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluetriangle_shape, stim_chr: 'bluetriangle', key_answer: 'A', data: {rule: 'shape', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'switch', variable: 'colorshape1', task: 'colorshape'}},
    {stimulus: bluecircle_color, stim_chr: 'bluecircle', key_answer: 'L', data: {rule: 'color', type: 'repeat', variable: 'colorshape1', task: 'colorshape'}},
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


