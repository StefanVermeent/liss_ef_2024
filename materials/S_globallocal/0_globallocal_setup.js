var preload_globloc01 = {
    type: jsPsychPreload,
    images: [
      'globallocal/img/black_e_of_f.png',
      'globallocal/img/black_e_of_p.png',
      'globallocal/img/black_e_of_t.png',
      'globallocal/img/black_h_of_f.png',
      'globallocal/img/black_h_of_p.png',
      'globallocal/img/black_h_of_t.png'
      ]
}  

var preload_globloc02 = {
    type: jsPsychPreload,
    images: [
      'globallocal/img/black_f_of_e.png',
      'globallocal/img/black_f_of_h.png',
      'globallocal/img/black_p_of_e.png',
      'globallocal/img/black_p_of_h.png',
      'globallocal/img/black_t_of_e.png',
      'globallocal/img/black_t_of_h.png'
      ]
}  

  
  
var Ge_Lf  = "<img src='globallocal/img/black_e_of_f.png' height=600px>";
var Ge_Lp  = "<img src='globallocal/img/black_e_of_p.png' height=600px>";
var Ge_Lt  = "<img src='globallocal/img/black_e_of_t.png' height=600px>";
var Gf_Le  = "<img src='globallocal/img/black_f_of_e.png' height=600px>";
var Gf_Lh  = "<img src='globallocal/img/black_f_of_h.png' height=600px>";
var Gh_Lf  = "<img src='globallocal/img/black_h_of_f.png' height=600px>";
var Gh_Lp  = "<img src='globallocal/img/black_h_of_p.png' height=600px>";
var Gh_Lt  = "<img src='globallocal/img/black_h_of_t.png' height=600px>";
var Gp_Le  = "<img src='globallocal/img/black_p_of_e.png' height=600px>";
var Gp_Lh  = "<img src='globallocal/img/black_p_of_h.png' height=600px>";
var Gt_Le  = "<img src='globallocal/img/black_t_of_e.png' height=600px>";
var Gt_Lh  = "<img src='globallocal/img/black_t_of_h.png' height=600px>";


var feedback = {
  type: jsPsychHtmlKeyboardResponse,
  stimulus: function(){
    
    var last_trial_rt = jsPsych.data.getLastTrialData().values()[0].rt;
    var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;
    
    if(last_trial_rt > 4000){
      return "<p style = 'color:red;font-size:40px'>Too slow!</p>"; 
    } else {
      if(last_trial_correct){
        return "<p style = 'color:green;font-size:40px'>Correct!</p>"; 
      } else {
        return "<p style = 'color:red;font-size:40px'>Incorrect!</p>"; 
      }}},
  trial_duration: 2000,
  choices: "NO_KEYS",
  data: {
    variable: 'feedback'
  }
};