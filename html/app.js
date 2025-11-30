(function () {
    const root = document.getElementById("wanted-root");
    const starsContainer = document.getElementById("wanted-stars");

    const MAX_STARS = 5;

    function setVisible(visible) {
        if (visible) root.classList.remove("hidden");
        else root.classList.add("hidden");
    }

    let lastLevel = -1;

    function updateWanted(level) {
        const wanted = Math.max(0, Math.min(MAX_STARS, Number(level) || 0));

        if (wanted <= 0) {
            setVisible(false);
            lastLevel = 0;
            return;
        }

        // activer UI si needed
        setVisible(true);

        // détecter changement de niveau
        const levelChanged = wanted !== lastLevel;
        lastLevel = wanted;

        // Reset étoiles
        starsContainer.innerHTML = "";

        for (let i = 1; i <= MAX_STARS; i++) {
            const div = document.createElement("div");
            div.classList.add("wanted-star");

            if (i <= wanted) {
                div.classList.add("active");
                div.textContent = "★";
            } else {
                div.classList.add("inactive");
                div.textContent = "★";
            }

            // appliquer clignotement SEULEMENT si changement
            if (levelChanged) {
                div.classList.add("wanted-blink");

                // retirer l’animation après 450ms
                setTimeout(() => {
                    div.classList.remove("wanted-blink");
                }, 450);
            }

            starsContainer.appendChild(div);
        }
    }


    window.addEventListener("message", (event) => {
        const data = event.data || {};

        if (data.action === "setWantedLevel") {
            updateWanted(data.level);
        }
    });

    setVisible(false);
})();
