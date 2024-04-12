
var animacysize_test = {
  type: jsPsychCategorizeHtml,
  choices: ['A','L'],
  correct_text: "",
  incorrect_text: "",
  feedback_duration: 250,
  show_stim_with_feedback: false,
  key_answer: function(){return jsPsych.timelineVariable('key_answer')},
  stimulus: function(){
    var stim = ""
    if(jsPsych.timelineVariable('data')['rule'] == "size") {
      stim += "<div style = 'text-align: center;'><h1>KLEINER of GROTER?<br></h1><br><br><br><div style = 'font-size:60px'>" + jsPsych.timelineVariable('stimulus') + "</div></div>";
    }
    if(jsPsych.timelineVariable('data')['rule'] == "animacy") {
      stim += "<div style = 'text-align: center;'><h1>LEVEND of NIET-LEVEND?<br></h1><br><br><br><div style = 'font-size:60px'>" + jsPsych.timelineVariable('stimulus') + "</div></div>";
    }
        return stim
      },
  prompt: "<br><br><br><div style='width: 600px; height:50px;'>" + prompt_living + prompt_smaller + prompt_larger + prompt_nonliving + "</div><br><br>" +
          "<div style='width: 600px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
  data: {
    stimulus: function(){return jsPsych.timelineVariable('stimulus')},
    rule: function(){return jsPsych.timelineVariable('data')['rule']},
    condition: function(){
      return jsPsych.timelineVariable('data')['type']
    },
    variable: function(){return jsPsych.timelineVariable('data')['variable']},
    task: function(){return jsPsych.timelineVariable('data')['task']},
  },
};

var animacysize_procedure01 = {
  timeline: [animacysize_test],
  timeline_variables: [
   {stimulus: 'gorilla', key_answer: 'L', data: {stimulus: 'gorilla', rule: 'size', type: 'first', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'stier', key_answer: 'L', data: {stimulus: 'stier', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'tractor', key_answer: 'L', data: {stimulus: 'tractor', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'schaap', key_answer: 'A', data: {stimulus: 'schaap', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'muis', key_answer: 'A', data: {stimulus: 'muis', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'blik', key_answer: 'A', data: {stimulus: 'blik', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'kever', key_answer: 'A', data: {stimulus: 'kever', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'kameel', key_answer: 'L', data: {stimulus: 'kameel', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'toren', key_answer: 'L', data: {stimulus: 'toren', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'sok', key_answer: 'A', data: {stimulus: 'sok', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'windmolen', key_answer: 'L', data: {stimulus: 'windmolen', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'goudvis', key_answer: 'A', data: {stimulus: 'goudvis', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'spijker', key_answer: 'A', data: {stimulus: 'spijker', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'pil', key_answer: 'L', data: {stimulus: 'pil', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'matras', key_answer: 'L', data: {stimulus: 'matras', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'spin', key_answer: 'A', data: {stimulus: 'spin', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'beer', key_answer: 'L', data: {stimulus: 'beer', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'tent', key_answer: 'L', data: {stimulus: 'tent', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'saxofoon', key_answer: 'L', data: {stimulus: 'saxofoon', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'pen', key_answer: 'L', data: {stimulus: 'pen', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'ooievaar', key_answer: 'A', data: {stimulus: 'ooievaar', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'kam', key_answer: 'A', data: {stimulus: 'kam', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'worm', key_answer: 'A', data: {stimulus: 'worm', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'egel', key_answer: 'A', data: {stimulus: 'egel', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'bus', key_answer: 'L', data: {stimulus: 'bus', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'mok', key_answer: 'A', data: {stimulus: 'mok', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'leeuw', key_answer: 'L', data: {stimulus: 'leeuw', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'orka', key_answer: 'L', data: {stimulus: 'orka', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'speld', key_answer: 'L', data: {stimulus: 'speld', rule: 'animacy', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'mus', key_answer: 'A', data: {stimulus: 'mus', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'wesp', key_answer: 'A', data: {stimulus: 'wesp', rule: 'animacy', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'kano', key_answer: 'L', data: {stimulus: 'kano', rule: 'size', type: 'switch', variable: 'animacysize1', task: 'animacysize'}},
   {stimulus: 'hert', key_answer: 'L', data: {stimulus: 'hert', rule: 'size', type: 'repeat', variable: 'animacysize1', task: 'animacysize'}},
  ],
};

//------------------------- Standard Shifting - Set 2

var animacysize_procedure02 = {
  timeline: [animacysize_test],
  timeline_variables: [
    {stimulus: 'knikker', key_answer: 'A', data: {stimulus: 'knikker', rule: 'size', type: 'first', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'ijsbeer', key_answer: 'L', data: {stimulus: 'ijsbeer', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'vork', key_answer: 'L', data: {stimulus: 'vork', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'iglo', key_answer: 'L', data: {stimulus: 'iglo', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'naald', key_answer: 'L', data: {stimulus: 'naald', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'rups', key_answer: 'A', data: {stimulus: 'rups', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'kuiken', key_answer: 'A', data: {stimulus: 'kuiken', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'lepel', key_answer: 'A', data: {stimulus: 'lepel', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'kikker', key_answer: 'A', data: {stimulus: 'kikker', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'olifant', key_answer: 'L', data: {stimulus: 'olifant', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'lantaarn', key_answer: 'L', data: {stimulus: 'lantaarn', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'raket', key_answer: 'L', data: {stimulus: 'raket', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'tijger', key_answer: 'L', data: {stimulus: 'tijger', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'slak', key_answer: 'A', data: {stimulus: 'slak', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'bril', key_answer: 'L', data: {stimulus: 'bril', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'rat', key_answer: 'A', data: {stimulus: 'rat', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'kanon', key_answer: 'L', data: {stimulus: 'kanon', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'vulkaan', key_answer: 'L', data: {stimulus: 'vulkaan', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'wolf', key_answer: 'A', data: {stimulus: 'wolf', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'fiets', key_answer: 'L', data: {stimulus: 'fiets', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'caravan', key_answer: 'L', data: {stimulus: 'caravan', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'geit', key_answer: 'A', data: {stimulus: 'geit', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'piano', key_answer: 'L', data: {stimulus: 'piano', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'stift', key_answer: 'L', data: {stimulus: 'stift', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'mug', key_answer: 'A', data: {stimulus: 'mug', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'vlinder', key_answer: 'A', data: {stimulus: 'vlinder', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'ring', key_answer: 'A', data: {stimulus: 'ring', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'mier', key_answer: 'A', data: {stimulus: 'mier', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'zeep', key_answer: 'L', data: {stimulus: 'zeep', rule: 'animacy', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'walvis', key_answer: 'A', data: {stimulus: 'walvis', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'dolfijn', key_answer: 'A', data: {stimulus: 'dolfijn', rule: 'animacy', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'schaar', key_answer: 'A', data: {stimulus: 'schaar', rule: 'size', type: 'switch', variable: 'animacysize2', task: 'animacysize'}},
    {stimulus: 'ezel', key_answer: 'L', data: {stimulus: 'ezel', rule: 'size', type: 'repeat', variable: 'animacysize2', task: 'animacysize'}},
  ]
};

var animacysize_interblock = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "Goed gedaan! U bent nu halverwege.<br>Neem even pauze als u dat nodig heeft en druk op 'verder' als u klaar bent voor de rest van het spel.<br><br>",
  choices: ['verder'],
  data: {
    task: 'animacysize',
    variable: 'interblock'
  }
}

var animacysize_pp_feedback = {
  type: jsPsychSurveyText,
  questions: [
    {prompt: 'Heeft u feedback op dit spel (bijvoorbeeld: duidelijkheid van de instructies; moeilijkheidsgraad; iets wat niet goed leek te werken)?<br>We zouden het op prijs stellen als u het ons hieronder laat weten!', name: 'user_feedback', rows:5, required: false},
  ],
  data: {
    variable: "pp_feedback",
    task: "animacysize_feedback"
  }
}
