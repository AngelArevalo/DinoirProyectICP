
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import RBTree "mo:base/RBTree";
import Random  "mo:base/Random";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";


actor Quizzis {

  var title: Text = "";
  type Question = {question: Text; respuesta_a: Text; respuesta_b: Text; correcta: Text;};
  var questions: RBTree.RBTree<Text, Question> = RBTree.RBTree(Text.compare);
  var randomNumber :Nat = 1;
  var adward : Nat = 1;
  var maximo : Nat = 1;
  let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
  let random = Random.Finite(seed);

  public query func getQuestion(entry: Text) : async Question {
    let question_for_entry :?Question = questions.get(entry);
    let question : Question = switch question_for_entry {
      case (null) {
        {
          question = ""; respuesta_a = ""; respuesta_b = ""; correcta= "";
        };
      };
      case (?question_for_entry) question_for_entry;
    };
    return question
  };

  public query func getReward() : async Text {
    adward := switch (random.binomial(Nat8.fromNat(maximo))) {
      case(?value) Nat8.toNat(value);
      case(null) 0;
    };
    return Nat.toText(randomNumber)
  };

  public func reply(quest: Text, reply: Text) : async Text {
    let question_for_entry :?Question = questions.get(quest);
    let question : Question = switch question_for_entry {
      case (null) {
        {
          question = ""; respuesta_a = ""; respuesta_b = ""; correcta= "";
        };
      };
      case (?question_for_entry) question_for_entry;
    };
    if (question.correcta == reply) {
      return "Correcto"
    } else {
      return "Incorrecto"
    }
  };

  public shared (msg) func createQuestions() : async [(Text, Question)] {
      questions.put("1", {question = "¿Cuantos años hay en un siglo?"; respuesta_a = "10 años"; respuesta_b = "100 años"; correcta = "100 años";});

      questions.put("2", {question = "¿Quien fue Da Vinci?"; respuesta_a = "Un doctor"; respuesta_b = "Un artista"; correcta = "Un artista";});

      questions.put("3", {question = "¿Cuantos Bytes hay en un KiloByte?"; respuesta_a = "1000 bytes"; respuesta_b = "10000 bytes"; correcta = "1000 bytes";});

      questions.put("4", {question = "¿Que no es un lenguaje de programacion?"; respuesta_a = "Python"; respuesta_b = "VSCode"; correcta = "VSCode";});

      questions.put("5", {question = "¿Que es un solsticio?"; respuesta_a = "La mayor declinacion del sol con respecto al ecuador"; respuesta_b = "El momento cuando la orbita de un planeta esta en su punto mas alejado"; correcta = "La mayor declinacion del sol con respecto al ecuador";});

      questions.put("6", {question = "¿Que significa 'Plvs Vltra'?"; respuesta_a = "Más allá"; respuesta_b = "Ultra luz"; correcta = "Más allá";});

      questions.put("7", {question = "¿Que es Nightcore?"; respuesta_a = "Una aplicacion de citas"; respuesta_b = "Un genero musical"; correcta = "Un genero musical";});

      questions.put("8", {question = "¿Quien de estas figuras uso antes una maquina de vapor?"; respuesta_a = "Edward Huber"; respuesta_b = "Jerónimo de Ayanz"; correcta = "Jerónimo de Ayanz";});
      return Iter.toArray(questions.entries())
  };
};