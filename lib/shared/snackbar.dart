import 'package:flutter/material.dart';

showSnackBarMessage(BuildContext context, String text, bool check) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: check ? Colors.green : const Color.fromARGB(255, 179, 89, 89),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Icon(
            check ? Icons.check_circle : Icons.error_outline,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                check ? "Success" : "Opps. An Error Occurd",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const Spacer(),
              Text(
                text,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              )
            ],
          ))
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 3,
  ));
}
