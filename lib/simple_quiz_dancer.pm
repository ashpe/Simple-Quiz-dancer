package simple_quiz_dancer;
use Dancer ':syntax';
use Modern::Perl;
use Simple::Quiz;

our $VERSION = '0.1';
our $quiz = Simple::Quiz->new(title => "Learning Cantonese", mode => "shuffle", filename => "questions.yaml");

get '/' => sub {

    $quiz->load_sections();
    template 'index', { title => $quiz->title, sections => $quiz->section_keys };
};

post '/' => sub {

    #$quiz->load_sections("previously_selected_sections");
    $quiz->start();
    redirect 'questions';
};

get '/questions' => sub {
    
    my $section = $quiz->next_section();
    my $question = $quiz->next_question();    

    template 'questions', { question => $question->{question}, section => $quiz->current_section, title => $quiz->title };
};

post '/questions' => sub {
    # store answer here
    # $quiz->answer($args);
    redirect 'result';
};

get '/result' => sub {
   # return answer, correctness of answer, section, title and have a link to go to next question. 
   my $question;
   template 'result', { answer => $question->{answer} }; 
};

true;
