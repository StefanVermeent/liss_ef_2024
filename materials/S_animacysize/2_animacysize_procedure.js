
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
      stim += "<div style = 'text-align: center;'><h1>KLEINER of GROTER?<br></h1><br><br><br><div style = 'font-size:60px'>" + jsPsych.timelineVariable('stim') + "</div></div>";
    }
    if(jsPsych.timelineVariable('data')['rule'] == "animacy") {
      stim += "<div style = 'text-align: center;'><h1>LEVEND of NIET-LEVEND?<br></h1><br><br><br><div style = 'font-size:60px'>" + jsPsych.timelineVariable('stim') + "</div></div>";
    }
        return stim
      },
  prompt: "<br><br><br><div style='width: 600px; height:50px;'>" + prompt_living + prompt_smaller + prompt_larger + prompt_nonliving + "</div><br><br>" +
          "<div style='width: 600px;'><h1 style='float: left; margin:0;'>A</h1><h1 style='float: right; margin:0;'>L</h1></div>",
  data: {
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
   {stim: 'gorilla',   key_answer: 'L', data: {rule: 'size', type: 'first', variable: 'test', task: 'animacysize'}},
   {stim: 'stier',     key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'tractor',   key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'schaap',    key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'mug',       key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'blik',      key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'kever',     key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'kameel',    key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'toren',     key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'sok',       key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'windmolen', key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'goudvis',   key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'spijker',   key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'pil',       key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'kraan',     key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'slak',      key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'beer',      key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'tent',      key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'saxofoon',  key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'pen',       key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'ooievaar',  key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'kam',       key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'wesp',      key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'egel',      key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'bus',       key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'mok',       key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'leeuw',     key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'orka',      key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'speld',     key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'muis',      key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'vlinder',   key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
   {stim: 'kano',      key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
   {stim: 'hert',      key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
  ],
};

//------------------------- Standard Shifting - Set 2

var animacysize_procedure02 = {
  timeline: [animacysize_test],
  timeline_variables: [
    {stim: 'knikker',  key_answer: 'A', data: {rule: 'size', type: 'first', variable: 'test', task: 'animacysize'}},
    {stim: 'ijsbeer',  key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'vork',     key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'iglo',     key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'naald',    key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'rat',      key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'worm',     key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'lepel',    key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'kikker',   key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'olifant',  key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'lantaarn', key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'raket',    key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'tijger',   key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'rups',     key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'bril',     key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'mus',      key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'kanon',    key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'vulkaan',  key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'wolf',     key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'fiets',    key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'caravan',  key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'geit',     key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'piano',    key_answer: 'L', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'stift',    key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'mier',     key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'spin',     key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'ring',     key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'konijn',   key_answer: 'A', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'zeep',     key_answer: 'L', data: {rule: 'animacy', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'walvis',   key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'dolfijn',  key_answer: 'A', data: {rule: 'animacy', type: 'repeat', variable: 'test', task: 'animacysize'}},
    {stim: 'schaar',   key_answer: 'A', data: {rule: 'size', type: 'switch', variable: 'test', task: 'animacysize'}},
    {stim: 'ezel',     key_answer: 'L', data: {rule: 'size', type: 'repeat', variable: 'test', task: 'animacysize'}},
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
    {prompt: 'Heb je feedback op dit spel (bijvoorbeeld: duidelijkheid van de instructies; moeilijkheidsgraad; iets wat niet goed leek te werken)?<br>We zouden het op prijs stellen als je het ons hieronder laat weten!', name: 'user_feedback', rows:5, required: false},
  ],
  data: {
    variable: "pp_feedback",
    task: "animacysize_feedback"
  }
}
