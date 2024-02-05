//------------------------- Shape stimuli

var yellowcircle   = "<svg width='250' height='250'><circle cx='125' cy='125' r='100' fill='yellow' stroke='black' stroke-width='4'/></svg>";
var bluecircle     = "<svg width='250' height='250'><circle cx='125' cy='125' r='100' fill='blue' stroke='black' stroke-width='4'/></svg>";
var yellowtriangle = "<svg width='250' height='250'><polygon points='25,225 125,25 225,225' fill='yellow' stroke='black' stroke-width='4'/></svg>";
var bluetriangle   = "<svg width='250' height='250'><polygon points='25,225 125,25 225,225' fill='blue' stroke='black' stroke-width='4'/></svg>";

//------------------------- Prompts to show to aid with responses-

var prompt_circle  = "<svg style='float:right;' width='100' height='100'><circle cx='40' cy='40' r='40' fill='black'/></svg>";
var prompt_tri     = "<svg style='float:left;' width='100' height='100'><polygon points='10,80 90,80 50,0' fill='black'/></svg>";
var prompt_yellow  = "<svg style='float:left;' width='100' height='100'><rect width='80' height='80' fill='yellow' stroke='black' stroke-width='4'/></svg>";
var prompt_blue    = "<svg style='float:right;' width='100' height='100'><rect width='80' height='80' fill='blue' stroke='black' stroke-width='4'/></svg>";

//------------------------- All possible shapes/colors with the rules displayed at the top

var yellowcircle_color   = "<div style = 'text-align: center;'><h1>Color</h1>" + yellowcircle   + "</div>";
var yellowcircle_shape   = "<div style = 'text-align: center;'><h1>Shape</h1>" + yellowcircle   + "</div>";
var bluecircle_color     = "<div style = 'text-align: center;'><h1>Color</h1>" + bluecircle     + "</div>";
var bluecircle_shape     = "<div style = 'text-align: center;'><h1>Shape</h1>" + bluecircle     + "</div>";
var yellowtriangle_color = "<div style = 'text-align: center;'><h1>Color</h1>" + yellowtriangle + "</div>";
var yellowtriangle_shape = "<div style = 'text-align: center;'><h1>Shape</h1>" + yellowtriangle + "</div>";
var bluetriangle_color   = "<div style = 'text-align: center;'><h1>Color</h1>" + bluetriangle   + "</div>";
var bluetriangle_shape   = "<div style = 'text-align: center;'><h1>Shape</h1>" + bluetriangle   + "</div>";

//------------------------- Obejects to hold trial information for the practice session

// Shape instructions

var shifting_shape_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: left;'>We are going to play a matching game with colors and shapes.<br><br></p>",
        "<p style = 'text-align: left;'> We will play the SHAPE game first.<br><br>" +
        "In the SHAPE game, choose the picture that is the same SHAPE as the picture in the middle of the screen.<br><br></p>",
        "If the picture is a TRIANGLE, press the LEFT arrow key:<br><br><br>Example:"+
        "<div style = 'text-align: center;'>" + yellowtriangle + "</div>" +
        "<br><br><br><div>" + prompt_tri + prompt_circle + "</div><br><br><br>",
        "If the picture is a CIRCLE, press the RIGHT arrow key:<br><br><br>Example:"+
        "<div style = 'text-align: center;'>" + bluecircle + "</div>" +
        "<br><br><br><div>" + prompt_tri + prompt_circle + "</div><br><br><br>",
        "<p style = 'text-align: left;'> Now you will practice playing the SHAPE game.<br><br>" +
        "Answer as fast as you can without making mistakes. If you make a mistake, just keep going.<br><br>" +
        "Click 'continue' to practice the SHAPE game.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "continue",
    button_label_previous: "go back",
    data: {variable: "shape_instructions", task: "shifting_abs_instruction"}
};

// Shape practice

var shifting_shape_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['ArrowLeft','ArrowRight'],
      correct_text: "<h1 style='text-align:center;'>Correct</h1>",
      incorrect_text:"<h1 style='text-align:center;'>Incorrect</h1>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<div style='width: 500px; height:50px;'>" + prompt_tri + prompt_circle + "</div><br><br>"+ 
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>&#x21E6</h1><h1 style='float: right; margin:0;'>&#x21E8</h1></div>",
      data: {variable: "shape_practice", rule: "shape", type: "repeat", task: "shifting_abs_practice"},
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
    {stimulus: yellowcircle_shape  , key_answer: 'ArrowRight'},
    {stimulus: bluecircle_shape    , key_answer: 'ArrowRight'},
    {stimulus: bluetriangle_shape  , key_answer: 'ArrowLeft'},
    {stimulus: yellowtriangle_shape, key_answer: 'ArrowLeft'}
  ]
};

var shifting_shape_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Would you like to practice the SHAPE game again?</p>",
  choices: ['No, I am ready to continue', 'Yes, practice again'],
  prompt: "",
  data: {variable: "shape_confirmation", task: "shifting_abs_practice"}
};

var shifting_shape_practice_loop = {
  timeline: [shifting_shape_practice,shifting_shape_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].button_pressed == 1){
      return true;
    } else {
      return false;
    }
  }
};

// Color instructions

var shifting_color_instructions = {
    type: jsPsychInstructions,
    pages: [
        "<p style = 'text-align: left;'>We can also match by COLOR. <br><br>In the COLOR game, choose the picture that is the same COLOR as the picture in the middle of the screen.<br><br></p>",
        "If the picture is YELLOW, press the LEFT arrow key:<br><br><br>Example:"+
        "<div style = 'text-align: center;'>" + yellowcircle + "</div>" +
        "<br><br><br><div>" + prompt_yellow + prompt_blue + "</div><br><br><br>",
        "If the picture is BLUE, press the RIGHT arrow key:<br><br><br>Example:"+
        "<div style = 'text-align: center;'>" + bluetriangle + "</div>" +
        "<br><br><br><div>" + prompt_yellow + prompt_blue + "</div><br><br><br>",
        "<p style = 'text-align: left;'>Now you will practice playing the COLOR game.<br><br>" +
        "Answer as fast as you can without making mistakes. If you make a mistake, just keep going.<br><br>" +
        "Click 'continue' to practice the COLOR game.</p>"
    ],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "continue",
    button_label_previous: "go back",
    data: {variable: "color_instructions", task: "shifting_abs_instructions"}
};

// Color practice

var shifting_color_practice = {
  timeline: [
    {
      type: jsPsychCategorizeHtml,
      choices: ['ArrowLeft','ArrowRight'],
      correct_text: "<h1 style='text-align:center;'>Correct</h1>",
      incorrect_text:"<h1 style='text-align:center;'>Incorrect</h1>",
      show_stim_with_feedback: false,
      feedback_duration: 500,
      prompt: "<div style='width: 500px; height:50px;'>" + prompt_yellow + prompt_blue + "</div><br><br>"+ 
              "<div style='width: 500px;'><h1 style='float: left; margin:0;'>&#x21E6</h1><h1 style='float: right; margin:0'>&#x21E8</h1></div>",
      data: {variable: "color_practice",rule: "color", type: "repeat", task: "shifting_abs_practice"},
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
    {stimulus: bluecircle_color     , key_answer: 'ArrowRight'},
    {stimulus: yellowcircle_color   , key_answer: 'ArrowLeft'},
    {stimulus: bluetriangle_color   , key_answer: 'ArrowRight'},
    {stimulus: yellowtriangle_color , key_answer: 'ArrowLeft'}
  ]
};

var shifting_color_confirmation = {
  type: jsPsychHtmlButtonResponse,
  stimulus: "<p>Would you like to practice the COLOR game again?</p>",
  choices: ['No, I am ready to continue', 'Yes, practice again'],
  prompt: "",
  data: {variable: 'color_confirmation', task: "shifting_abs_practice"}
};

var shifting_color_practice_loop = {
  timeline: [shifting_color_practice,shifting_color_confirmation],
  loop_function: function(data){
    if(jsPsych.data.get().last(1).values()[0].button_pressed == 1){
      return true;
    } else {
      return false;
    }
  }
};

// Shifting instructions

var shifting_abs_instructions = {
    type: jsPsychInstructions,
    pages: ["<div style = 'text-align: left;'>Nice work!<br><br>" + 
            "Now, we are going to play both games together.<br><ul>" +
            "<li>When you see the word SHAPE, choose the picture that is the same SHAPE as the picture.</li>" +
            "<li>When you see the word COLOR, choose the picture that is the same COLOR as the picture in the middle of the screen.</li>" +
            "</ul><p>You will see the following pictures to help remind you:</p></div><br><br>" +
            "<div style='width: 60%; padding-left:20%; padding-right:20%;'>" +
            "<div>" + prompt_yellow + prompt_tri + prompt_circle + prompt_blue + "</div><br><br><br><br>" +
            "<div><h1 style='float: left; margin:0;'>&#x21E6</h1><h1 style='float: right; margin:0;'>&#x21E8</h1></div><br>" +
            "<div><p style='float: left; margin:0;'>always on the left</p><p style='float: right; margin:0;'>always on the right</p></div>" + 
            "</div><br><br>" +
            "<p style = 'text-align: left;'><b>Note that you won't receive feedback for the rest of the game.</b><br><br>" +
            "Click 'continue' to play!</p>"],
    show_clickable_nav: true,
    allow_backward: true,
    key_forward: -1,
    key_backward: -1,
    button_label_next: "continue",
    data: {variable: "shifting_instructions", task: "shifting_abs_instructions"}
};