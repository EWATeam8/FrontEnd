import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manufacturer/models/chat.model.dart';
import 'package:manufacturer/models/product.model.dart';

final DateFormat _dateFormat = DateFormat.Hm();

Widget buildUserMessage(Chat chat) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                chat.message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _dateFormat.format(chat.dateTime),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildBotMessage(Chat chat, Function handleSubmitted) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    constraints: const BoxConstraints(maxWidth: 100),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.message,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (chat.options != null) ...[
              const SizedBox(height: 5),
              ...chat.options!.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 2,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 131, 97, 255),
                      ),
                      onPressed: () => handleSubmitted(option),
                      child: Text(option),
                    ),
                  )),
            ],
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _dateFormat.format(chat.dateTime),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildProductRecommendations(Chat chat) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    constraints: const BoxConstraints(maxWidth: 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            chat.message,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 5),
        ...chat.products!
            .map((product) => _buildProductCard(product, chat.dateTime)),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            _dateFormat.format(chat.dateTime),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildProductCard(Product product, DateTime dateTime) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 250,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 131, 97, 255),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.network(
                product.imageUrl,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.description,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
