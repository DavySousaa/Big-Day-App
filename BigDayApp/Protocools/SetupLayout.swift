

protocol SetupLayout {
    func addSubViews()
    func setupConstraints()
    func setupStyle()
}

extension SetupLayout {
    func setup() {
        addSubViews()
        setupConstraints()
        setupStyle()
    }
}
