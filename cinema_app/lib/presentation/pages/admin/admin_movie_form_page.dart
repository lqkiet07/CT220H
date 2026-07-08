import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/movie.dart';
import '../../providers/movie_provider.dart';

class AdminMovieFormPage extends StatefulWidget {
  final String? movieId;

  const AdminMovieFormPage({super.key, this.movieId});

  @override
  State<AdminMovieFormPage> createState() => _AdminMovieFormPageState();
}

class _AdminMovieFormPageState extends State<AdminMovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _ratingController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _genresController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.movieId != null) {
      _isEditing = true;
      _loadMovieData();
    }
  }

  void _loadMovieData() {
    final provider = context.read<MovieProvider>();
    try {
      final movie = provider.trendingMovies.firstWhere((m) => m.id == widget.movieId);
      _titleController.text = movie.title;
      _posterUrlController.text = movie.posterUrl;
      _ratingController.text = movie.rating.toString();
      _durationController.text = movie.durationMinutes.toString();
      _priceController.text = movie.basePrice.toString();
      _genresController.text = movie.genres.join(', ');
    } catch (e) {
      // Not found
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _posterUrlController.dispose();
    _ratingController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<MovieProvider>();
    final movie = Movie(
      id: _isEditing ? widget.movieId! : 'm_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      posterUrl: _posterUrlController.text.trim(),
      rating: double.tryParse(_ratingController.text.trim()) ?? 0.0,
      durationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
      basePrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      genres: _genresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    );

    try {
      if (_isEditing) {
        await provider.updateMovie(movie);
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Sửa phim thành công');
        }
      } else {
        await provider.addMovie(movie);
        if (mounted) {
          SnackbarUtils.showSuccess(context, 'Thêm phim thành công');
        }
      }
      if (mounted) {
        context.pop(); // Go back
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Lỗi: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(_isEditing ? 'Sửa thông tin Phim' : 'Thêm Phim Mới', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Tên phim',
                icon: Icons.movie_creation,
                validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _posterUrlController,
                label: 'URL Ảnh Poster',
                icon: Icons.image,
                validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _ratingController,
                      label: 'Đánh giá (0-10)',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Bắt buộc';
                        final num = double.tryParse(v);
                        if (num == null || num < 0 || num > 10) return 'Không hợp lệ';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _durationController,
                      label: 'Thời lượng (phút)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Bắt buộc';
                        if (int.tryParse(v) == null) return 'Không hợp lệ';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _priceController,
                label: 'Giá vé cơ bản (VNĐ)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Bắt buộc';
                  if (double.tryParse(v) == null) return 'Không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _genresController,
                label: 'Thể loại (cách nhau bởi dấu phẩy)',
                icon: Icons.category,
                validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isEditing ? 'CẬP NHẬT PHIM' : 'THÊM PHIM MỚI',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: validator,
    );
  }
}
