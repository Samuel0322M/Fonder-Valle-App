import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:models/consulta_transunion_response.dart';
import 'package:user_interface/pages/home_page.dart';
import 'package:user_interface/providers/response_consulta_provider.dart';
import 'package:user_interface/resources/theme/appbar.dart';
import 'package:user_interface/utils/general_api.dart';

class TransunionQuestionsPage extends StatefulWidget {
    final String applicationId;
    final int prospectId;
    final Map<String, dynamic>? examen;
    final String cedulaCliente;
  const TransunionQuestionsPage({super.key,   required this.applicationId,
    required this.prospectId, required this.examen, required this.cedulaCliente});

  static const String route = '/transunion-questions';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    final applicationId = args['applicationId'] as String;
    final prospectId = args['prospectId'] as int; // o String
    final cedulaCliente = args['cedulaCliente'] as String;
    return TransunionQuestionsPage(
      applicationId: applicationId,
      prospectId: prospectId,
      examen: args['examen'] as Map<String, dynamic>,
      cedulaCliente: cedulaCliente,
    );
  }

  @override
  State<TransunionQuestionsPage> createState() => _TransunionQuestionsPageState();
}

class _TransunionQuestionsPageState extends State<TransunionQuestionsPage> {

  // JSON original

  var responseConsultaProvider= ResponseConsultaProvider();

  late List<Map<String, dynamic>> preguntasList;
  final Map<String, int> respuestasSeleccionadas = {};
  int preguntaActual = 0;

  @override
  void initState() {
    super.initState();
    preguntasList = _transformarPreguntas(widget.examen!);
    responseConsultaProvider.inicializarBox();
  }

  List<Map<String, dynamic>> _transformarPreguntas(Map<String, dynamic> json) {
    final preguntas = json["Questions"]["Question"] as List;

    return preguntas.map((pregunta) {
      final respuestas = (pregunta["Answer"] as List)
          .asMap()
          .entries
          .map((entry) => {
                "id": entry.key,
                "texto": entry.value["#text"],
                "isSelected": entry.value["@IsSelected"] == "true"
              })
          .toList();

      return {"id": pregunta["@Id"], "pregunta": pregunta["@Text"], "respuestas": respuestas};
    }).toList();
  }

  void _siguientePregunta() {
    if (!respuestasSeleccionadas.containsKey(preguntasList[preguntaActual]["id"])) {
      _mostrarAlertaSimple("Debes seleccionar una respuesta antes de continuar.");
      return;
    }

    if (preguntaActual < preguntasList.length - 1) {
      setState(() {
        preguntaActual++;
      });
    } else {
      _enviarRespuestas();
    }
  }

  void _mostrarAlertaSimple(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Atención"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }

  void _mostrarAlertaRedireccion(String mensaje) {
     if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Atención"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
               if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              Future.microtask(() {
                Navigator.of(context).popUntil(
                  (route) => route.settings.name == HomePage.route,
                );
              });
            },
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }

  Future<void> _enviarRespuestas() async {
    final preguntasOriginales = widget.examen?["Questions"]["Question"] as List;

    for (var pregunta in preguntasOriginales) {
      final idPregunta = pregunta["@Id"];
      final indiceSeleccionado = respuestasSeleccionadas[idPregunta];

      for (var i = 0; i < (pregunta["Answer"] as List).length; i++) {
        pregunta["Answer"][i]["@IsSelected"] = (i == indiceSeleccionado) ? "true" : "false";
      }
    }


        /*
        
        final response = await ApiService.bodyApi(
        body: {
          "operacion" : "realiza_examen",
          "id_prospecto" : widget.prospectId,
          "respuestaTransunion":{
          "Examen" : widget.examen,
          "Decision": "Valor no disponible",
          "ApplicationId" : {"0" : widget.applicationId},
          "CurrentQueue": {"0": "ShowExam"}
          }
        },
      ); 
      
      
    final url = Uri.parse("http://10.0.2.2:3001/api_creacion_prospecto_finan/codigo/");
    final body = {
          "operacion" : "realiza_examen",
          "id_prospecto" : widget.prospectId,
          "respuestaTransunion":{
          "Examen" : widget.examen,
          "Decision": "Valor no disponible",
          "ApplicationId" : {"0" : widget.applicationId},
          "CurrentQueue": {"0": "ShowExam"}
          }
        };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    */


    try {

    final url = Uri.parse("http://10.0.2.2:3001/api_creacion_prospecto_finan/codigo/"); 
    final body = {
          "operacion" : "realiza_examen",
          "id_prospecto" : widget.prospectId,
          "respuestaTransunion":{
          "Examen" : widget.examen,
          "Decision": "Valor no disponible",
          "ApplicationId" : {"0" : widget.applicationId},
          "CurrentQueue": {"0": "ShowExam"}
          }
        };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("response body: ${response.body}");

    final Map<String, dynamic> parsed = jsonDecode(response.body);
    final responseData = parsed['data']['response'];

    final serverCode = responseData['code']; // <- cambiado nombre
    final decision = responseData['decision'];
    final homologada = responseData['homologada'];
    final descripcion = responseData['descripcion'];
    final codeudor = responseData['codeudor'];

    final consultaTransunionResponse = ConsultaTransunionResponse(
      code: serverCode,
      decision: decision,
      homologada: homologada,
      descripcion: descripcion,
      codeudor: codeudor,
      idProspect: widget.prospectId.toString(),
      cedulaCliente: widget.cedulaCliente,
    );
    await responseConsultaProvider.eliminarConsultaResponse(widget.cedulaCliente);
    await responseConsultaProvider.guardarConsultaResponse(
        widget.cedulaCliente, consultaTransunionResponse);

        print("hola estoy aqui este es el response ${response.statusCode}");

      if(response.statusCode == 200){
        if(decision == "Pass"){
          _mostrarAlertaRedireccion("¡Respuestas enviadas correctamente!");
        } else if (decision == "Refer" || decision == "Decline") {
          _mostrarAlertaRedireccion("Lo sentimos, su solicitud no ha sido aprobada.");
        } else {
          _mostrarAlertaRedireccion("Ocurrio un error");
        }
      }
      else {
      _mostrarAlertaRedireccion("Ocurrio un error");
    }
  } catch (e) {
    _mostrarAlertaRedireccion("Ocurrio un error interno");
    print(e);
  }

    } 
  @override
  Widget build(BuildContext context) {
    final pregunta = preguntasList[preguntaActual];

    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pregunta ${preguntaActual + 1} de ${preguntasList.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              pregunta["pregunta"],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              (pregunta["respuestas"] as List).length,
              (i) {
                final opcion = pregunta["respuestas"][i];
                return RadioListTile<int>(
                  title: Text(opcion["texto"]),
                  value: opcion["id"],
                  groupValue: respuestasSeleccionadas[pregunta["id"]],
                  onChanged: (value) {
                    setState(() {
                      respuestasSeleccionadas[pregunta["id"]] = value!;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _siguientePregunta,
                child: Text(
                  preguntaActual < preguntasList.length - 1 ? "Siguiente" : "Enviar Respuestas",
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
