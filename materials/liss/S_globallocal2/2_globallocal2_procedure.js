// Fixation cross
var globallocal2_fixation = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    var stim = "<div class='grid-container'>" +
              "<div></div>" +
              "<div style='font-size:60px;'>+</div>" +
              "<div></div>" +
            "</div>" +
            "<br><br><br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>" + prompt_square + "<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'><br>" + prompt_rectangle +"<br><br>L</h1></div>"
  return stim
  },
  choices: 'NO_KEYS',
  trial_duration: function(){
        return jsPsych.randomization.sampleWithoutReplacement([900, 925, 950, 975, 1000, 1025, 1050, 1075, 1100], 1)[0];
      },
  data: {
    variable: 'fixation',
    task: "globallocal2",
    stimulus: function(){return jsPsych.timelineVariable('stim_chr')}
  }
}

var globallocal2_target = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  key_answer: function(){return jsPsych.timelineVariable('key_answer')},
  feedback_duration: 1000,
  show_stim_with_feedback: false,
  prompt: "<br><br><br><br><div style='width: 600px;'><h1 style='float: left; font-size: 20px; margin:0;'>" + prompt_square + "<br><br>A</h1><h1 style='float: right; margin:0; font-size: 20px;'><br>" + prompt_rectangle +"<br><br>L</h1></div>",
  stimulus: function(){
    var stim = ""

    if(jsPsych.timelineVariable('data')['rule'] == 'global'){

      stim += "<div class='grid-container'>" +
                "<div>" + elephantleft + "</div>" +
                "<div id='figure' style='visibility:hidden;'>" + jsPsych.timelineVariable('stimulus') + "</div>" +
                "<div>" + elephantright + "</div>" +
              "</div>"
    }

    if(jsPsych.timelineVariable('data')['rule'] == 'local'){
      stim += "<div class='grid-container'>" +
                "<div>" + mouseleft + "</div>" +
                "<div id='figure' style='visibility:hidden;'>" + jsPsych.timelineVariable('stimulus') + "</div>" +
                "<div>" + mouseright + "</div>" +
              "</div>"
    }
    return stim
  },
  on_load: function() {
    setTimeout(function() {
      document.getElementById('figure').style.visibility = "visible";
    }, 1000);
  },
  data: {
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    condition: function(){return jsPsych.timelineVariable('data')['type']},
    congruency: function(){return jsPsych.timelineVariable('data')['congruency']},
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
    stimulus: function(){return jsPsych.timelineVariable('stim_chr')}
  },
}


var globallocal2_procedure01 = {
timeline: [globallocal2_fixation, globallocal2_target],
  timeline_variables: [
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'first', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2', task: 'globallocal2'}},
  ]
}


var globallocal2_procedure02 = {
timeline: [globallocal2_fixation, globallocal2_target],
  timeline_variables: [
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'first', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'A', data: {rule: 'local', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECsq, stim_chr: 'RECsq', key_answer: 'L', data: {rule: 'global', type: 'switch', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: RECrec, stim_chr: 'RECrec', key_answer: 'L', data: {rule: 'local', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'switch', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQrec, stim_chr: 'SQrec', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'incongruent', variable: 'globallocal2_01', task: 'globallocal2'}},
    {stimulus: SQsq, stim_chr: 'SQsq', key_answer: 'A', data: {rule: 'global', type: 'repeat', congruency: 'congruent', variable: 'globallocal2_01', task: 'globallocal2'}},
  ]
}


