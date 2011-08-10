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

true;
