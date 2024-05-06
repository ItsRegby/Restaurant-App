document.addEventListener("DOMContentLoaded", function() {
    const reservationDateField = document.getElementById('reservation_date');

    reservationDateField.addEventListener('input', function() {
        const createReservationBtn = document.getElementById('create_reservation_btn');

        if (this.value) {
            createReservationBtn.disabled = false;
        } else {
            createReservationBtn.disabled = true;
        }
    });
});
