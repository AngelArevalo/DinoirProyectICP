
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

  // Preguntas (Solicitud, respuesta_a, respuesta_b, respuesta_correcta y estado de la solucion)
  type Question = {question: Text; respuesta_a: Text; respuesta_b: Text; correcta: Text; respuesta: Bool};
  // Arbol de objetos
  var questions: RBTree.RBTree<Text, Question> = RBTree.RBTree(Text.compare);

  // Aleatoriedad
  var adward : Nat = 1;
  var maximo : Nat = 8;
  let seed : Blob = "\14\C9\72\09\03\D4\D5\72\82\95\E5\43\AF\FA\A9\44\49\2F\25\56\13\F3\6E\C7\B0\87\DC\76\08\69\14\CF";
  let random = Random.Finite(seed);

  // Funcion para obtener las pregunta
  public query func getQuestion(entry: Text) : async Question {
    // Buscar pregunta con el valor dado
    let question_for_entry :?Question = questions.get(entry);
    let question : Question = switch question_for_entry {
      case (null) {
        {
          question = ""; respuesta_a = ""; respuesta_b = ""; correcta = ""; respuesta = false
        };
      };
      case (?question_for_entry) question_for_entry;
    };
    // Retorna objeto completo, incluyendo respuesta correcta y estado de la solicitud
    return question
  };

  // Funcion para obtener una recompensa aleatoria
  public query func getReward() : async Bool {
    // Obtener valor aleatorio entre 1 y la cantidad de preguntas
    adward := switch (random.binomial(Nat8.fromNat(maximo))) {
      case(?value) Nat8.toNat(value);
      case(null) 0;
    };
    // Buscar pregunta con el valor aleatorio
    let question_for_entry :?Question = questions.get(Nat.toText(adward));
    let question : Question = switch question_for_entry {
      case (null) {
        {
          question = ""; respuesta_a = ""; respuesta_b = ""; correcta = ""; respuesta = false
        };
      };
      case (?question_for_entry) question_for_entry;
    };
    // Retorna el estado de la respuesta, en caso de ser true da un premio y en caso de ser false da un castigo.
    return question.respuesta
  };

  // Funcion para dar un respuesta a una pregunta
  public func reply(quest: Text, reply: Text) : async Text {
    // Buscar pregunta con el primer valor dado
    let question_for_entry :?Question = questions.get(quest);
    var question : Question = switch question_for_entry {
      case (null) {
        {
          question = ""; respuesta_a = ""; respuesta_b = ""; correcta = ""; respuesta = false
        };
      };
      case (?question_for_entry) question_for_entry;
    };
    // Validar si la respuesta es la correcta
    if (question.correcta == reply) {
      questions.put(quest, {question = question.question; respuesta_a = question.respuesta_a; respuesta_b = question.respuesta_b; correcta = question.correcta; respuesta = true;});
      return "Correcto" // En caso de ser correcto devuelve un aviso y actualiza el estado de la pregunta
    } else {
      return "Incorrecto" // En caso de ser incorrecto devuelve un aviso.
    }
  };

  // Funcion para crear las preguntas disponibles
  public shared (msg) func createQuestions() : async [(Text, Question)] {
    // Crear cada una de las preguntas de forma pre-establecida
    questions.put("1", {question = "¿Cuantos años hay en un siglo?"; respuesta_a = "10 años"; respuesta_b = "100 años"; correcta = "100 años"; respuesta = false;});
    questions.put("2", {question = "¿Quien fue Da Vinci?"; respuesta_a = "Un doctor"; respuesta_b = "Un artista"; correcta = "Un artista"; respuesta = false;});
    questions.put("3", {question = "¿Cuantos Bytes hay en un KiloByte?"; respuesta_a = "1000 bytes"; respuesta_b = "10000 bytes"; correcta = "1000 bytes"; respuesta = false;});
    questions.put("4", {question = "¿Que no es un lenguaje de programacion?"; respuesta_a = "Python"; respuesta_b = "VSCode"; correcta = "VSCode"; respuesta = false;});
    questions.put("5", {question = "¿Que es un solsticio?"; respuesta_a = "La mayor declinacion del sol con respecto al ecuador"; respuesta_b = "El momento cuando la orbita de un planeta esta en su punto mas alejado"; correcta = "La mayor declinacion del sol con respecto al ecuador"; respuesta = false;});
    questions.put("6", {question = "¿Que significa 'Plvs Vltra'?"; respuesta_a = "Más allá"; respuesta_b = "Ultra luz"; correcta = "Más allá"; respuesta = false;});
    questions.put("7", {question = "¿Que es Nightcore?"; respuesta_a = "Una aplicacion de citas"; respuesta_b = "Un genero musical"; correcta = "Un genero musical"; respuesta = false;});
    questions.put("8", {question = "¿Quien de estas figuras uso antes una maquina de vapor?"; respuesta_a = "Edward Huber"; respuesta_b = "Jerónimo de Ayanz"; correcta = "Jerónimo de Ayanz"; respuesta = false;});
    // Retornar todas las preguntas del tema (En este caso inicial)
    return Iter.toArray(questions.entries())
  };
};