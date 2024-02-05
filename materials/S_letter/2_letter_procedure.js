//------------------------- Standard letter - Set 1

var letter_test = {
  type: jsPsychCategorizeHtml,
  stimulus: function(){
    var stim = ""

    if (jsPsych.timelineVariable('data')['rule'] == 'oddeven'){
      stim += "<div style = 'text-align: center; color: 'blue';><h1>EVEN of ONEVEN?<br></h1><br><br><div style = 'font-size:80px'>" + jsPsych.timelineVariable('stim') + "</div></div><br><br><br><br>";
    }
    if (jsPsych.timelineVariable('data')['rule'] == "largesmall"){
      stim += "<div style = 'text-align: center; color: 'blue';><h1>KLEINER of GROTER?<br></h1><br><br><div style = 'font-size:80px'>" + jsPsych.timelineVariable('stim') + "</div></div><br><br><br><br>";
    }
    return stim
  },
  choices: ['A','L'],
  key_answer: function(){return jsPsych.timelineVariable('key_answer')},
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 250,
  show_stim_with_feedback: false,
  prompt: "<div style='width: 600px; height:50px;'>" + prompt_left + prompt_right + "</div><br><br>",
};

var letter_test_procedure01 = {
  timeline: [letter_test],
    timeline_variables: [
    {stim: '7', key_answer: 'L', data: {rule: 'oddeven', type: 'first', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '1', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '3', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '8', key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '3', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '7', key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '2', key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '1', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '3', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '4', key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '2', key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '6', key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '7', key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '8', key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '8', key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '7', key_answer: 'L', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '7', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '1', key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '8', key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '8', key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '1', key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '3', key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting1'}},
    {stim: '9', key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting1'}},
  ],
}

var letter_test_procedure02 = {
  timeline: [letter_test],
    timeline_variables: [
{stim: 2, key_answer: 'A', data: {rule: 'largesmall', type: 'first', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 4, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 1, key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 4, key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 4, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 7, key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 7, key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 8, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 3, key_answer: 'L', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 2, key_answer: 'A', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 2, key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 8, key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 3, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 1, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 7, key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 3, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 2, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 6, key_answer: 'A', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 8, key_answer: 'A', data: {rule: 'oddeven', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 8, key_answer: 'L', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 1, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 2, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 2, key_answer: 'A', data: {rule: 'largesmall', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 7, key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 7, key_answer: 'L', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 1, key_answer: 'A', data: {rule: 'largesmall', type: 'repeat', variable: 'letter_shifting', task: 'letter_shifting2'}},
{stim: 4, key_answer: 'A', data: {rule: 'oddeven', type: 'switch', variable: 'letter_shifting', task: 'letter_shifting2'}},
  ],
};

var letter_interblock = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "Good job! You are halfway there.<br>Take a break if needed and press 'continue' when you are ready for the final block.",
  choices: ['Continue'],
  data: {
    task: 'letter',
    variable: 'interblock'
  }
}
