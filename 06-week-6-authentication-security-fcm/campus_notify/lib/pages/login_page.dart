import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_errors.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
	const LoginPage({super.key});

	@override
	ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();

	@override
	void dispose() {
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _login() async {
		await ref.read(authStateProvider.notifier).login(
					_emailController.text.trim(),
					_passwordController.text,
				);
	}

	@override
	Widget build(BuildContext context) {
		final authState = ref.watch(authStateProvider);
		return Scaffold(
			appBar: AppBar(title: const Text('Masuk')),
			body: Center(
				child: ConstrainedBox(
					constraints: const BoxConstraints(maxWidth: 420),
					child: Padding(
						padding: const EdgeInsets.all(24),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								TextField(
									controller: _emailController,
									keyboardType: TextInputType.emailAddress,
									decoration: const InputDecoration(labelText: 'Email'),
								),
								TextField(
									controller: _passwordController,
									obscureText: true,
									decoration: const InputDecoration(labelText: 'Kata sandi'),
								),
								const SizedBox(height: 16),
								if (authState.hasError)
									Text(
										friendlyErrorMessage(authState.error!),
										style: TextStyle(color: Theme.of(context).colorScheme.error),
									),
								FilledButton(
									onPressed: authState.isLoading ? null : _login,
									child: authState.isLoading
											? const CircularProgressIndicator()
											: const Text('Masuk'),
								),
							],
						),
					),
				),
			),
		);
	}
}
