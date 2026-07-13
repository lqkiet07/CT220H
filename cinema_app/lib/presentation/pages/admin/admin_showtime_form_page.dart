import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/movie.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/showtime_provider.dart';
import '../../providers/movie_provider.dart';

class AdminShowtimeFormPage extends StatefulWidget {
  final String? showtimeId;

  const AdminShowtimeFormPage({super.key, this.showtimeId});

  @override
  State<AdminShowtimeFormPage> createState() => _AdminShowtimeFormPageState();
}

class _AdminShowtimeFormPageState extends State<AdminShowtimeFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedMovieId;
  String? _selectedRoomId;
  DateTime? _selectedDateTime;
  final _pricingFactorController = TextEditingController(text: '1.0');

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.showtimeId != null) {
      _isEditing = true;
      _loadShowtimeData();
    }
  }

  void _loadShowtimeData() {
    final provider = context.read<ShowtimeProvider>();
    try {
      final showtime = provider.showtimes.firstWhere((s) => s.id == widget.showtimeId);
      _selectedMovieId = showtime.movieId;
      _selectedRoomId = showtime.roomId;
      _selectedDateTime = showtime.startTime;
      _pricingFactorController.text = showtime.dynamicPricingFactor.toString();
    } catch (e) {
      // Not found
    }
  }

  @override
  void dispose() {
    _pricingFactorController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: AppColors.surface,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedMovieId == null || _selectedRoomId == null || _selectedDateTime == null) {
      SnackbarUtils.showError(context, 'Vui lòng chọn đầy đủ Phim, Phòng chiếu và Thời gian!');
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<ShowtimeProvider>();
    final showtime = Showtime(
      id: _isEditing ? widget.showtimeId! : 's_${DateTime.now().millisecondsSinceEpoch}',
      movieId: _selectedMovieId!,
      roomId: _selectedRoomId!,
      startTime: _selectedDateTime!,
      dynamicPricingFactor: double.tryParse(_pricingFactorController.text.trim()) ?? 1.0,
    );

    try {
      if (_isEditing) {
        await provider.updateShowtime(showtime);
        if (mounted) SnackbarUtils.showSuccess(context, 'Cập nhật suất chiếu thành công');
      } else {
        await provider.addShowtime(showtime);
        if (mounted) SnackbarUtils.showSuccess(context, 'Thêm suất chiếu thành công');
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) SnackbarUtils.showError(context, 'Lỗi: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final movies = movieProvider.trendingMovies;
    final rooms = MockData.getRooms();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(_isEditing ? 'Sửa Suất Chiếu' : 'Thêm Suất Chiếu Mới', style: const TextStyle(fontWeight: FontWeight.bold)),
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
              // Chọn Phim
              _buildDropdown<String>(
                label: 'Chọn Phim',
                icon: Icons.movie,
                value: _selectedMovieId,
                items: movies.map((m) => DropdownMenuItem(value: m.id, child: Text(m.title))).toList(),
                onChanged: (v) => setState(() => _selectedMovieId = v),
              ),
              const SizedBox(height: 16),
              
              // Chọn Phòng
              _buildDropdown<String>(
                label: 'Chọn Phòng Chiếu',
                icon: Icons.meeting_room,
                value: _selectedRoomId,
                items: rooms.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                onChanged: (v) => setState(() => _selectedRoomId = v),
              ),
              const SizedBox(height: 16),
              
              // Chọn Thời Gian
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDateTime != null 
                              ? DateFormat('HH:mm - dd/MM/yyyy').format(_selectedDateTime!)
                              : 'Chọn Giờ & Ngày chiếu',
                          style: TextStyle(
                            color: _selectedDateTime != null ? Colors.white : Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_month, color: Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hệ số giá
              TextFormField(
                controller: _pricingFactorController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Hệ số giá (Mặc định: 1.0, VD cao điểm: 1.2, 1.5)',
                  labelStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.monetization_on, color: Colors.white54),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Bắt buộc';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Phải là số > 0';
                  return null;
                },
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
                          _isEditing ? 'CẬP NHẬT' : 'THÊM SUẤT CHIẾU',
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

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: AppColors.surface,
      style: const TextStyle(color: Colors.white, fontSize: 16),
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
      ),
      validator: (v) => v == null ? 'Vui lòng chọn' : null,
    );
  }
}
