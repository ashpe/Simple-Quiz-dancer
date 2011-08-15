package simple_quiz_dancer;
use Dancer ':syntax';
use Modern::Perl;
use Simple::Quiz;

our $VERSION = '0.1';

get '/' => sub {

    my $tmp_quiz = Simple::Quiz->new(
        title    => "Learning Cantonese",
        mode     => "shuffle",
        filename => "questions.yaml"
    );

    $tmp_quiz->load_sections();
    template 'index', { title => $tmp_quiz->title, sections => $tmp_quiz->section_keys };

};

post '/' => sub {
    my $sections = params->{sections};
    if( !UNIVERSAL::isa( $sections, "ARRAY" ) ) {
        $sections = [];
        push @{$sections}, params->{sections};
    }


    my $quiz = Simple::Quiz->new(
        title    => "Learning Cantonese",
        mode     => "shuffle",
        filename => "questions.yaml"
    );

    $quiz->load_sections($sections);
    $quiz->start();

    session quiz => $quiz;
    redirect 'questions';
};

get '/questions' => sub {
    my $quiz     = session('quiz');
    my $section  = $quiz->next_section();
    my $question = $quiz->next_question();

    if( scalar @{ $quiz->completed_questions } == 0 ) {
        $section  = $quiz->next_section();
        $question = $quiz->next_question();
    }

    if( $quiz->status == 0 ) {
        my $total_correct   = $quiz->correct_answers;
        my $total_questions = $quiz->total_questions;
        my $title           = $quiz->title;
        $quiz->reset();
        session quiz => $quiz;
        template 'finished',
          {
            total_correct   => $total_correct,
            total_questions => $total_questions,
            title           => $title
          };
    }
    else {
        session quiz => $quiz;
        template 'questions',
          {
            question => $question->{question},
            section  => $quiz->current_section,
            title    => $quiz->title
          };
    }
};

post '/questions' => sub {
    my $quiz = session('quiz');
    # store answer here
    my $answer = params->{question};
    $quiz->answer($answer);
    session quiz => $quiz;
    redirect 'result';
};

get '/result' => sub {

    my $quiz = session('quiz');
    # return answer, correctness of answer, section, title and have a link to go to next question.
    my $question     = $quiz->sections->{ $quiz->current_section }->[ $quiz->current_question ];
    my $check_answer = $quiz->answer_question_approx( $quiz->answer );
    session quiz => $quiz;
    template 'result',
      {
        question => $question,
        correct  => $check_answer,
        title    => $quiz->title,
        section  => $quiz->current_section
      };
};

true;
