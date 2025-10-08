import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:models/consulta_transunion_response.dart';
import 'package:user_interface/pages/home_page.dart';
import 'package:user_interface/providers/response_consulta_provider.dart';
import 'dart:async';
import 'package:user_interface/resources/theme/appbar.dart';
import 'package:user_interface/utils/general_api.dart';

// ignore: camel_case_types
class transunionCodeValidation extends StatefulWidget {
  final String applicationId;
  final int prospectId;
  final String cedulaCliente;

  const transunionCodeValidation({
    super.key,
    required this.applicationId,
    required this.prospectId,
    required this.cedulaCliente
  });

  static const String route = '/transunion-code';
  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    print("argumentos : $args");
    final applicationId = args['applicationId'] as String;
    final prospectId = args['prospectId'] as int; // o String según venga
    final idNumber = args['cedulaCliente'] as String;

    return transunionCodeValidation(
      applicationId: applicationId,
      prospectId: prospectId, 
      cedulaCliente: idNumber,
    );
  }

  @override
  State<transunionCodeValidation> createState() => _transunionCodeValidationState();
}

class _transunionCodeValidationState extends State<transunionCodeValidation> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  var responseConsultaProvider= ResponseConsultaProvider();

  int _focusedIndex = 0;

  late Timer _timer;
  int _totalSeconds = 2 * 60 + 1;
  bool _canRequestNewCode = false;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    responseConsultaProvider.inicializarBox();

    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }
  }

    void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  void _startTimer() {
    _canRequestNewCode = false;
    _totalSeconds = 2 * 60 + 1;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        setState(() {
          _totalSeconds--;
        });
      } else {
        setState(() {
          _canRequestNewCode = true;
        });
        _timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

@override
void dispose() {
  for (final c in _controllers) {
    c.dispose();
  }
  for (final f in _focusNodes) {
    f.dispose();
  }
  _timer.cancel(); // <- corregido, ya no reinicia el contador
  super.dispose();
}



  String get code => _controllers.map((controller) => controller.text).join();


   /* 

       final response = await ApiService.bodyApi(
        body: {
          "operacion": "confirma_otp",
          "id_prospecto": widget.prospectId,
          "respuestaTransunion": {
            "CurrentQueue": {"0": "PinVerification_OTPInput"},
            "Decision": "Valor no disponible",
            "ApplicationId": {"0": widget.applicationId},
            "Examen": {"@OTP": enteredCode}
          }
        },
        );

   
   */

Future<void> submitCode() async {
  final enteredCode = code;

  if (enteredCode.length != 4) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Código no válido"),
        content: const Text("Por favor ingresa los 4 dígitos"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
    return;
  }

  setState(() {
    _isButtonDisabled = true;
  });

  try {

    final url = Uri.parse("http://10.0.2.2:3001/api_creacion_prospecto_finan/codigo/"); 

    final body = {
      "operacion": "confirma_otp",
      "id_prospecto": widget.prospectId,
      "respuestaTransunion": {
        "CurrentQueue": {"0": "PinVerification_OTPInput"},
        "Decision": "Valor no disponible",
        "ApplicationId": {"0": widget.applicationId},
        "Examen": {"@OTP": enteredCode}
      }
    };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

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

    await responseConsultaProvider.guardarConsultaResponse(
        widget.cedulaCliente, consultaTransunionResponse);

    if (response.statusCode == 200) {
      if (decision == "Pass") {
        _showResultDialog("Éxito", "Identidad validada exitosamente");
      } else if (decision == "Refer") {
        _showResultDialog("Atención",
            "Su solicitud requiere revisión manual. Nos pondremos en contacto con usted pronto.");
      } else if (decision == "Decline") {
        _showResultDialog("Lo sentimos",
            "Su solicitud ha sido rechazada. Para más información, por favor contáctenos.");
      } else {
        _showErrorDialog("Respuesta inesperada del servidor.");
      }
    } else {
      _showErrorDialog("El código ingresado es incorrecto");
    }
  } catch (e) {
    _showErrorDialog("Ocurrió un error al validar el código: $e");
  } finally {
    setState(() {
      _isButtonDisabled = false; // <- siempre reactivamos el botón
    });
  }
}

void _showResultDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
          child: const Text("Aceptar"),
        ),
      ],
    ),
  );
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Aceptar"),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Center(
                child: Text(
              "Ingresa el codigo",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFocused = _focusedIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: isFocused ? 70 : 60,
                  height: isFocused ? 70 : 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFocused ? Colors.blue : Colors.grey,
                      width: isFocused ? 2 : 1,
                    ),
                    color: isFocused ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(counterText: "", border: InputBorder.none),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onCodeChanged(value, index),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: submitCode,
                child: Text(_isButtonDisabled ? "Procesando..." : "Validar")),
            const SizedBox(height: 40),
            Text(
              "Debes esperar para solicitar un nuevo codigo:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(_formattedTime, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            if (_canRequestNewCode)
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Notificacion"),
                          content: Text("Se solicito un nuevo codigo"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Aceptar"),
                            ),
                          ],
                        );
                      },
                    );
                    _startTimer();
                  },
                  child: Text("Solicitar codigo nuevamente"))
          ],
        ),
      ),
    );
  }
}
